# frozen_string_literal: true

# ============================================================================
# School Data Cleanup Rake Tasks
# ============================================================================
#
# These tasks help fix two common data-quality issues in production:
#   1. Schools with a missing or invalid `country` value.
#   2. Schools whose `grade_level` doesn't match what their teachers report
#      or what their name implies.
#
# Both tasks are **dry-run by default** — they only print what they would
# change. Pass APPLY=true to actually persist the fixes:
#
#   rails schools:fix_countries              # dry-run report
#   rails schools:fix_countries APPLY=true   # apply fixes
#
#   rails schools:fix_grade_levels           # dry-run report
#   rails schools:fix_grade_levels APPLY=true
#
# ============================================================================

namespace :schools do

  # --------------------------------------------------------------------------
  # Task 1: Fix missing / invalid countries
  # --------------------------------------------------------------------------
  #
  # Strategy (tried in order for each school):
  #   a) If state is a valid US state abbreviation → country is "US".
  #   b) Infer from the website's top-level domain (TLD):
  #      e.g. .uk → "GB", .de → "DE", .ro → "RO".
  #      Generic TLDs like .com / .org / .edu are skipped.
  #   c) Reverse-geocode the school's lat/lng via the Google Maps API
  #      (requires BACKEND_MAPS_API_KEY to be set).
  #   d) If none of the above work, the school is listed as "unfixable"
  #      so an admin can update it manually.
  # --------------------------------------------------------------------------
  desc "Report (and optionally fix) schools with missing or invalid country"
  task fix_countries: :environment do
    # Determine whether we're actually writing to the DB.
    apply = ENV["APPLY"] == "true"

    puts apply ? "\n=== APPLYING country fixes ===" : "\n=== DRY RUN — pass APPLY=true to save ==="
    puts ""

    # Build the set of valid ISO-3166 alpha-2 country codes for quick lookup.
    # Example members: "US", "GB", "DE", "RO", …
    valid_codes = ISO3166::Country.all.map(&:alpha2).to_set

    # Also build the set of valid US state abbreviations so we can detect
    # "this school is clearly in the US" even when country is blank.
    us_states = School::VALID_STATES.to_set

    # A list of generic TLDs that tell us nothing about the country.
    generic_tlds = %w[com org edu net io gov mil int info].to_set

    # Collect all schools whose country is NULL, empty, or not a valid code.
    bad_schools = School.where(country: [nil, ""])
                        .or(School.where.not(country: valid_codes.to_a))

    puts "Found #{bad_schools.count} school(s) with missing/invalid country.\n\n"

    # Counters for the summary at the end.
    fixed   = 0
    skipped = 0

    bad_schools.find_each do |school|
      proposed_country = nil
      method_used      = nil

      # --- Strategy (a): Check if the state looks like a US state -----------
      if school.state.present? && us_states.include?(school.state.strip.upcase)
        proposed_country = "US"
        method_used = "US state abbreviation '#{school.state}'"
      end

      # --- Strategy (b): Infer from website TLD -----------------------------
      # Only try if we haven't already found a country above.
      if proposed_country.nil? && school.website.present?
        begin
          # Extract the hostname from the URL.  Example:
          #   "https://www.school.ro/about" → "www.school.ro"
          host = URI.parse(school.website).host
          if host.present?
            # The TLD is the last part after the final dot.
            #   "www.school.ro" → "ro"
            tld = host.split(".").last.upcase

            # Only use the TLD if it's NOT a generic one and IS a valid code.
            if !generic_tlds.include?(tld.downcase) && valid_codes.include?(tld)
              proposed_country = tld
              method_used = "website TLD '.#{tld.downcase}'"
            end
          end
        rescue URI::InvalidURIError
          # If the URL can't be parsed, just skip this strategy.
        end
      end

      # --- Strategy (c): Reverse-geocode from lat/lng -----------------------
      # Only try if we still don't have a country AND the school has coords.
      if proposed_country.nil? && school.lat.present? && school.lng.present?
        country_from_coords = reverse_geocode_country(school.lat, school.lng)
        if country_from_coords && valid_codes.include?(country_from_coords)
          proposed_country = country_from_coords
          method_used = "reverse geocoding (#{school.lat}, #{school.lng})"
        end
      end

      # --- Print result for this school -------------------------------------
      if proposed_country
        puts "  [FIX] ##{school.id} \"#{school.name}\" (#{school.city}, #{school.state})"
        puts "         Current country: #{school.country.inspect}"
        puts "         Proposed:        #{proposed_country}  (via #{method_used})"

        if apply
          # save(validate: false) because some legacy records may also be
          # missing other required fields; we only want to fix country here.
          school.update_column(:country, proposed_country)
          puts "         ✓ Saved."
        end

        fixed += 1
      else
        # None of our heuristics could determine the country.
        puts "  [SKIP] ##{school.id} \"#{school.name}\" (#{school.city}, #{school.state})"
        puts "         website: #{school.website.inspect}  lat/lng: #{school.lat}, #{school.lng}"
        puts "         ⚠ Could not infer country — needs manual review."
        skipped += 1
      end

      puts ""
    end

    # --- Summary ------------------------------------------------------------
    puts "---"
    puts "Total:   #{bad_schools.count}"
    puts "Fixable: #{fixed}   |   Needs manual review: #{skipped}"
    puts apply ? "All fixable records have been updated." : "(Dry run — no changes written.)"
    puts ""
  end

  # --------------------------------------------------------------------------
  # Task 2: Fix inaccurate grade levels
  # --------------------------------------------------------------------------
  #
  # Two heuristics are combined:
  #
  #   a) Name-based: If a school's name contains a keyword like "High School",
  #      "Elementary", "Middle School", "Community College", or "University"
  #      but its grade_level enum doesn't match, flag it.
  #
  #   b) Teacher-based: Look at the `education_level` of the teachers linked
  #      to each school. If the **majority** of teachers indicate a different
  #      level than the school's grade_level, flag the mismatch.
  #
  #      Mapping from Teacher.education_level → School.grade_level:
  #        teacher middle_school (0)  →  school middle_school (1)
  #        teacher high_school   (1)  →  school high_school   (2)
  #        teacher college       (2)  →  school university    (4)
  #
  # Schools where both heuristics agree on a fix are labeled [HIGH CONFIDENCE].
  # Schools where only one heuristic fires are labeled [LOW CONFIDENCE].
  # --------------------------------------------------------------------------
  desc "Report (and optionally fix) schools with likely-wrong grade levels"
  task fix_grade_levels: :environment do
    apply = ENV["APPLY"] == "true"

    puts apply ? "\n=== APPLYING grade-level fixes ===" : "\n=== DRY RUN — pass APPLY=true to save ==="
    puts ""

    # This hash maps substrings in a school name to the expected grade_level
    # enum key. The order matters: we check the most specific terms first so
    # "Middle School" isn't accidentally matched by a later, broader rule.
    name_keywords = {
      "community college" => :community_college,
      "university"        => :university,
      "college"           => :university,        # "Boston College" etc.
      "high school"       => :high_school,
      "middle school"     => :middle_school,
      "elementary"        => :elementary,
      "primary school"    => :elementary,
    }

    # Maps a Teacher's education_level integer to the closest School grade_level
    # symbol.  Teacher education_level enum: middle_school=0, high_school=1, college=2.
    # School grade_level enum: elementary=0, middle_school=1, high_school=2,
    #                          community_college=3, university=4.
    teacher_to_school_grade = {
      "middle_school" => :middle_school,   # teacher says middle school → school middle_school
      "high_school"   => :high_school,     # teacher says high school   → school high_school
      "college"       => :university,      # teacher says college       → school university
    }

    # Eager-load teachers to avoid N+1 queries when we inspect each school.
    schools = School.includes(:teachers).order(:name)

    puts "Scanning #{schools.count} school(s)...\n\n"

    flagged = 0

    schools.find_each do |school|
      # Current grade level — may be nil for legacy records.
      current_grade = school.grade_level  # e.g. "high_school" (string from enum)

      # ------------------------------------------------------------------
      # Heuristic (a): Check the school's name for grade-level keywords.
      # ------------------------------------------------------------------
      name_suggestion = nil
      # Downcase the name once for case-insensitive matching.
      lower_name = school.name.to_s.downcase
      name_keywords.each do |keyword, grade_sym|
        if lower_name.include?(keyword)
          name_suggestion = grade_sym
          break  # Stop at the first (most specific) match.
        end
      end

      # ------------------------------------------------------------------
      # Heuristic (b): Look at what the linked teachers say.
      # ------------------------------------------------------------------
      teacher_suggestion = nil

      # Only consider teachers who actually have an education_level set
      # (i.e., not nil and not the legacy default of -1).
      teachers_with_level = school.teachers.select do |t|
        t.education_level_before_type_cast.present? &&
          t.education_level_before_type_cast.to_i >= 0
      end

      if teachers_with_level.any?
        # Count how many teachers fall into each education_level category.
        # Example result: { "high_school" => 5, "middle_school" => 1 }
        level_counts = teachers_with_level
          .group_by(&:education_level)    # group by the string label
          .transform_values(&:count)      # count each group

        # Find the level with the most teachers.
        most_common_teacher_level = level_counts.max_by { |_level, count| count }&.first

        # Map that teacher level to the corresponding school grade_level.
        if most_common_teacher_level && teacher_to_school_grade.key?(most_common_teacher_level)
          teacher_suggestion = teacher_to_school_grade[most_common_teacher_level]
        end
      end

      # ------------------------------------------------------------------
      # Decide whether to flag this school.
      # ------------------------------------------------------------------
      # We flag it if at least one heuristic suggests a DIFFERENT grade_level
      # than what the school currently has.
      name_mismatch    = name_suggestion    && name_suggestion.to_s    != current_grade
      teacher_mismatch = teacher_suggestion && teacher_suggestion.to_s != current_grade

      # Skip this school if neither heuristic found a problem.
      next unless name_mismatch || teacher_mismatch

      # Determine confidence: both heuristics agree → high; otherwise → low.
      both_agree = name_mismatch && teacher_mismatch &&
                   name_suggestion == teacher_suggestion
      confidence = both_agree ? "HIGH" : "LOW"

      # Pick the proposed fix. Prefer the value both agree on; otherwise,
      # prefer the name-based suggestion (it's more deterministic).
      proposed = if both_agree
                   name_suggestion
                 elsif name_mismatch
                   name_suggestion
                 else
                   teacher_suggestion
                 end

      flagged += 1

      # --- Print details for this school ----------------------------------
      puts "  [#{confidence} CONFIDENCE] ##{school.id} \"#{school.name}\""
      puts "    Current grade_level:  #{current_grade || '(nil)'}"
      puts "    Proposed grade_level: #{proposed}"

      if name_mismatch
        puts "    ↳ Name contains keyword suggesting: #{name_suggestion}"
      end

      if teacher_mismatch
        teacher_summary = teachers_with_level
          .group_by(&:education_level)
          .transform_values(&:count)
          .map { |level, cnt| "#{level}=#{cnt}" }
          .join(", ")
        puts "    ↳ Teacher education levels (#{teachers_with_level.size} teachers): #{teacher_summary}"
        puts "      Majority suggests school should be: #{teacher_suggestion}"
      end

      # Only auto-apply HIGH CONFIDENCE fixes to avoid incorrect updates.
      if apply && both_agree
        school.update_column(:grade_level, School.grade_levels[proposed])
        puts "    ✓ Saved (high confidence)."
      elsif apply
        puts "    ⊘ Skipped (low confidence — review manually)."
      end

      puts ""
    end

    # --- Summary ------------------------------------------------------------
    puts "---"
    puts "Total schools scanned: #{schools.count}"
    puts "Flagged:               #{flagged}"
    puts apply ? "High-confidence fixes have been applied." : "(Dry run — no changes written.)"
    puts ""
  end
end

# ============================================================================
# Helper: Reverse-geocode lat/lng → ISO alpha-2 country code
# ============================================================================
# Uses the same Google Maps API key the app already uses for forward geocoding
# in MapsService. Returns nil if the key is missing or the API call fails.
#
# The Google Geocoding API response includes an array of address_components,
# one of which has type "country". Its `short_name` is the ISO alpha-2 code.
#
# Example response fragment:
#   { "short_name": "RO", "long_name": "Romania", "types": ["country", ...] }
# ============================================================================
def reverse_geocode_country(lat, lng)
  api_key = ENV["BACKEND_MAPS_API_KEY"]

  # If there's no API key configured, we can't call Google.
  if api_key.blank?
    # Only print this warning once so the output isn't flooded.
    @_geo_warning_shown ||= begin
      puts "  ⚠ BACKEND_MAPS_API_KEY is not set — skipping reverse geocoding."
      true
    end
    return nil
  end

  # Build the reverse-geocoding URL.
  # `latlng` param tells Google to do a reverse lookup.
  url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=#{lat},#{lng}&key=#{api_key}"

  # Make the HTTP request (HTTParty is already a dependency of this app).
  response = HTTParty.get(url)

  # If the API didn't return a successful result, bail out.
  return nil unless response["status"] == "OK"

  # Dig into the first result's address components to find the one
  # whose `types` array includes "country".
  components = response.dig("results", 0, "address_components") || []
  country_component = components.find { |c| c["types"].include?("country") }

  # Return the ISO alpha-2 code (e.g. "US", "RO", "GB"), or nil.
  country_component&.dig("short_name")
rescue StandardError => e
  # Network errors, JSON parse errors, etc. — don't crash the whole task.
  puts "  ⚠ Reverse geocoding failed for (#{lat}, #{lng}): #{e.message}"
  nil
end
