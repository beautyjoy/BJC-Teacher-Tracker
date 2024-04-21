namespace :db do
    desc "Populate the database with fake teacher data"
    task populate_teachers: :environment do
        # Populate database with 5 US and 5 INTERNATIONAL schools
        valid_states = School.get_valid_states
        grade_levels = School.get_grade_levels
        school_types = School.get_school_types
        available_countries = School.get_available_countries
        number_of_US_schools = 5
        number_of_international_schools = 5

        # Create US schools
        number_of_US_schools.times do
            school = School.create!(
                name: Faker::Educator.university,
                state: valid_states.sample,
                city: Faker::Address.city, 
                country: 'US',
                website: Faker::Internet.url,
                grade_level: grade_levels.sample,
                school_type: school_types.sample
            )
        end

        # Create international schools
        number_of_international_schools.times do
            school = School.create!(
                name: Faker::Educator.university,
                city: Faker::Address.city, 
                country: available_countries.sample,
                website: Faker::Internet.url,
                grade_level: grade_levels.sample,
                school_type: school_types.sample
            )
        end
        
        number_of_teachers = 30
        statuses = Teacher.get_statuses
        education_levels = Teacher.get_education_levels
        all_languages = Teacher.get_languages
        school_ids = School.pluck(:id)

        number_of_teachers.times do
            # Sample a random number of languages
            sampled_languages = all_languages.sample(rand(1..3))
            teacher = Teacher.create!(
                first_name: Faker::Name.first_name,
                last_name: Faker::Name.last_name,
                snap: Faker::Internet.username,
                school_id: school_ids.sample,
                personal_website: Faker::Internet.domain_name,
                status: statuses.sample,
                more_info: Faker::Lorem.sentence(word_count: 20),
                education_level: education_levels.sample, 
                languages: sampled_languages
            )
            if teacher.persisted?
                 # Generate an email using the first_name and last_name from the teacher instance
                email = Faker::Internet.email(name: "#{teacher.first_name} #{teacher.last_name}", separators: ['.'])
                EmailAddress.create!(
                    teacher_id: teacher.id,
                    email: email,
                    primary: true
                )
            end
        end
  
      puts "#{number_of_US_schools} US schools created. \n
#{number_of_US_schools} international schools created. \n
#{number_of_teachers} teachers created."
    end
end