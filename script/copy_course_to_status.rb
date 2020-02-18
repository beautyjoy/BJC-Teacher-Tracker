OTHER = 4
Teacher.all.find_in_batches do |group|
  group.each do |teacher|
    teacher.status = Teacher.statuses[teacher.course]
    if teacher.status.nil?
      teacher.other = teacher.course
      teacher.status = OTHER
    end
    teacher.save!
  end
end
