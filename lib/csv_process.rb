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
    #       :school_state, :school_website, :school_grade_level, :school_type, :school_tags, :school_nces_id
    #
    # Returns:
    #   An array [
    #     success_count (int),
    #     school_count (int),
    #     failed_email ([str]),
    #     failed_email_count (int),
    #     failed_noemail_count (int),
    #     update_count (int)
    #   ]
    school_column = [:name, :city, :state, :website, :grade_level, :school_type, :tags, :nces_id]
    teacher_value = [[]]
    teacher_column = [:first_name, :last_name, :education_level, :email, :more_info, :personal_website, :snap, :status, :school_id]

    success_count = 0
    failed_email_count = 0
    failed_noemail_count = 0
    update_count = 0
    failed_email = []
    school_count = 0

    teacher_hash_array.each do |row|
      teacher_db = Teacher.find_by(email: row[:email]) || Teacher.find_by(snap: row[:snap])
      if teacher_db
        # make sure teacher doesn't already exist
        flag = false
        if !row[:school_id]
          # If there is no school id
          failed_email_count += 1
          failed_email.append(row[:email])
          next
        elsif School.find_by(id: row[:school_id])
          # If there is a valid school id
          teacher_value = { first_name: row[:first_name], last_name: row[:last_name], education_level: row[:education_level],
          more_info: row[:more_info], personal_website: row[:personal_website], status: row[:status], school_id: row[:school_id] }
          teacher_db.assign_attributes(teacher_value)
          flag = true
        end
        if teacher_db.save
          if flag
            update_count += 1
          end
          next
        else
          failed_email_count += 1
          failed_email.append(row[:email])
        end
        next
      elsif !row[:school_id]
        # If there is no school id (different from having invalid school id)
        exist_shool = School.find_by(name: row[:school_name])
        if !exist_shool
          new_school_value = [[row[:school_name], row[:school_city], row[:school_state], row[:school_website], row[:school_grade_level], row[:school_type], row[:school_tags], row[:school_nces_id]]]
          School.import school_column, new_school_value
          new_school = School.find_by(name: row[:school_name])
          school_count += 1
          if new_school
            teacher_value = [[row[:first_name], row[:last_name], row[:education_level], row[:email], row[:more_info], row[:personal_website], row[:snap], row[:status], new_school.id]]
            new_school.assign_attributes({ teachers_count: 1 })
            new_school.save
          end
        else
          teacher_value = [[row[:first_name], row[:last_name], row[:education_level], row[:email], row[:more_info], row[:personal_website], row[:snap], row[:status], exist_shool.id]]
        end
      elsif School.find_by(id: row[:school_id])
        # If there is a valid school id
        teacher_value = [[row[:first_name], row[:last_name], row[:education_level], row[:email], row[:more_info], row[:personal_website], row[:snap], row[:status], row[:school_id]]]
      else
        # school_id is provided, but invalid
        if row[:email]
          failed_email_count += 1
          failed_email.append(row[:email])
        else
          failed_noemail_count += 1
        end
        next
      end
      Teacher.import teacher_column, teacher_value
      success_count += 1
    end
    [success_count, school_count, failed_email, failed_email_count, failed_noemail_count, update_count]
  end

  def add_flash_message(count)
    # Assigns the flash messages for teacher csv upload
    #
    # Params:
    #   count: An array [
    #     success_count (int),
    #     school_count (int),
    #     failed_email ([str]),
    #     failed_email_count (int),
    #     failed_noemail_count (int),
    #     update_count (int)
    #   ]
    #
    # Returns: Nothing
    success_count = count[0]
    school_count = count[1]
    failed_email = count[2]
    failed_email_count = count[3]
    failed_noemail_count = count[4]
    update_count = count[5]
    if success_count > 0
      flash[:success] = "Successfully imported #{success_count} teachers"
    end
    if school_count > 0
      flash[:notice] = "#{school_count} schools has been created"
    end
    if failed_email_count > 0
      flash[:alert] = "#{failed_email_count} teachers has failed with following emails:   "
      for email in failed_email do
        flash[:alert] += " [ #{email} ] "
      end
    end

    if failed_noemail_count > 0
      flash[:warning] = "#{failed_noemail_count} teachers has failed without emails"
    end

    if update_count > 0
      flash[:info] = "#{update_count} teachers has been updated"
    end
  end
end
