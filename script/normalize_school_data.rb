# frozen_string_literal: true

# Usage: rails runner script/normalize_school_data.rb
def set_usa_schools!
  schools = School.where.not(state: "International")
  puts "Updating #{schools.count} schools to have country 'US'"
  schools.update_all(country: "US")
end

set_usa_schools!

def cleanup_school_websites
  schools = School.where.not(website: nil)
  schools.each do |school|
    begin
      uri = URI.parse(school.website).normalize.to_s
    rescue URI::InvalidURIError
      puts "Invalid URI: #{school.website}"
      uri = school.website.lowercase.strip
    end
    school.update(website: uri)
  end
end

cleanup_school_websites

def set_country_for_international_schools!
  # Set the country code based on the domain name
  schools = School.where(state: "International")
  schools.each do |school|
    domain = URI.parse(school.website).host
    country = domain.split(".").last.upcase
    if ISO3166::Country.find_country_by_alpha2(country)
      school.update(country:, state: nil)
    else
      puts "Invalid country code. School: #{school.id} #{school.name}, #{country} #{school.website}"
    end
  end
end

set_country_for_international_schools!
