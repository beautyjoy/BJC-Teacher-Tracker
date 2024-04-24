module SchoolCreator
    def self.create_schools(number_of_schools, is_us)
        valid_states = School.get_valid_states
        grade_levels = School.grade_levels.keys
        school_types = School.school_types.keys
        available_countries = ISO3166::Country.all.map(&:alpha2)

        school_ids = []
        number_of_schools.times do 
            school = School.create!(
                name: Faker::Educator.university,
                state: is_us ? valid_states.sample : nil,
                city: Faker::Address.city, 
                country: is_us ? "US" : available_countries.sample,
                website: Faker::Internet.url,
                grade_level: grade_levels.sample,
                school_type: school_types.sample
            )
            school_ids.push(school.id)
        end
        return school_ids
    end
end
            