namespace :db do
    desc "Populate the database with fake teacher data"
    task populate_teachers: :environment do
        number_of_teachers = 10

        # Need to populate schools first
        statuses = Teacher.get_statuses
        education_levels = Teacher.get_education_levels
        all_languages = Teacher.get_languages

        number_of_teachers.times do
            # Sample a random number of languages
            sampled_languages = all_languages.sample(rand(1..3))
            teacher = Teacher.create!(
                first_name: Faker::Name.first_name,
                last_name: Faker::Name.last_name,
                snap: Faker::Internet.username,
                school_id: 1,
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
  
      puts "#{number_of_teachers} teachers created with detailed information."
    end
end