# frozen_string_literal: true

module CsvProcess
  def process_record(teacher_hash_array)
    # Creates or updates a teacher / school for each hash element in teacher_hash_array.
    # For each entry in the csv:
    #   If invalid :school_id => create/update fails.
    #   If no :school_id => create the school data from hash if no school w/ same name exists
    #   If no :email => fails to create/update teacher, no school is created
    #
    # Params:
    #   teacher_hash_array: Array of hash elements where each hash represents a row in the csv.
    #     Each hash contains the following keys: :first_name, :last_name, :education_level, :email,
    #       :more_info, :personal_website, :snap, :status, :school_id, :school_name, :school_city,
    #       :school_state, :school_country, :school_website, :school_grade_level, :school_type,
    #       :school_tags, :school_nces_id
    #
    # Returns:
    #   csv_import_summary_hash: A hash {
    #     success_count : (int),
    #     school_count : (int),
    #     failed_emails : Array of strings,
    #     failed_email_count : (int),
    #   }
    csv_import_summary_hash = { school_count: 0, success_count: 0, fail_count: 0, failed_emails: [] }

    teacher_hash_array.each do |row|
      email = row[:email].to_s.strip.downcase.presence

      # A row with no email can be neither matched nor created. Looking one up
      # with a blank value would match an arbitrary teacher and overwrite them.
      if email.nil?
        record_failure(csv_import_summary_hash, row[:email])
        next
      end

      school = School.find_by(id: row[:school_id])
      if !row[:school_id] # If there is no school id (different from having invalid school id)
        school = School.find_by(name: row[:school_name])
        if !school # Prevent creating the same school multiple times if same csv uploaded again
          school = School.new(school_params_from_row(row))
          if school.save
            csv_import_summary_hash[:school_count] += 1
          else
            record_failure(csv_import_summary_hash, row[:email])
            next # don't try to create teacher
          end
        end
        # Either way the teacher params below need the resolved school.
        row[:school_id] = school.id
      elsif !school # row[:school_id] exists, but is invalid
        record_failure(csv_import_summary_hash, row[:email])
        next # don't try to create teacher
      end

      # Emails live on EmailAddress; teachers.email is a legacy column that is
      # NULL for every teacher created since the email_addresses migration.
      teacher = Teacher.joins(:email_addresses).find_by(email_addresses: { email: })
      teacher ||= Teacher.find_by(snap: row[:snap]) if row[:snap].present?

      if teacher
        teacher.assign_attributes(teacher_update_params_from_row(row))
      else
        teacher = Teacher.new(teacher_new_params_from_row(row))
        teacher.email_addresses.build(email:, primary: true)
      end

      if teacher.save
        csv_import_summary_hash[:success_count] += 1
      else
        record_failure(csv_import_summary_hash, row[:email])
      end
    end

    csv_import_summary_hash
  end

  def add_flash_message(csv_import_summary_hash)
    # Assigns the flash messages for teacher csv upload
    #
    # Params:
    #   csv_import_summary_hash: A hash {
    #     success_count : (int),
    #     school_count : (int),
    #     failed_emails : Array of strings,
    #     failed_email_count : (int),
    #   }
    #
    # Returns: Nothing
    if csv_import_summary_hash[:success_count] > 0
      flash[:success] = "Successfully created/updated #{csv_import_summary_hash[:success_count]} teachers"
    end
    if csv_import_summary_hash[:school_count] > 0
      flash[:notice] = "#{csv_import_summary_hash[:school_count]} schools has been created"
    end
    if csv_import_summary_hash[:fail_count] > 0
      failed = csv_import_summary_hash[:failed_emails].map { |email| " [ #{email} ] " }.join
      flash[:alert] = "#{csv_import_summary_hash[:fail_count]} teachers has failed with following emails:   #{failed}"
    end
  end

  private
  def record_failure(csv_import_summary_hash, email)
    csv_import_summary_hash[:fail_count] += 1
    csv_import_summary_hash[:failed_emails].append(email)
  end

  # NOTE: no :email key -- teachers.email is the legacy column. The primary
  # address is built as an EmailAddress by the caller.
  def teacher_new_params_from_row(row)
    { first_name: row[:first_name],
      last_name: row[:last_name],
      education_level: row[:education_level],
      more_info: row[:more_info],
      personal_website: row[:personal_website],
      status: row[:status],
      school_id: row[:school_id],
      snap: row[:snap] }
  end

  def teacher_update_params_from_row(row)
    { first_name: row[:first_name],
      last_name: row[:last_name],
      education_level: row[:education_level],
      more_info: row[:more_info],
      personal_website: row[:personal_website],
      status: row[:status],
      school_id: row[:school_id] }
  end

  def school_params_from_row(row)
    { name: row[:school_name],
      city: row[:school_city],
      state: row[:school_state],
      # School validates country for presence and ISO-3166 inclusion. Without a
      # mapping here every school-creating row fails validation, so default to
      # US -- the implicit value for every school predating the country column.
      country: row[:school_country].presence || "US",
      website: row[:school_website],
      grade_level: row[:school_grade_level],
      school_type: row[:school_type],
      tags: row[:school_tags],
      nces_id: row[:school_nces_id] }
  end
end
