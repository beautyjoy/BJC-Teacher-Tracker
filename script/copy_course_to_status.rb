OTHER = 4
Teacher.all.find_in_batches do |group|
  group.each do |teacher|
    teacher.status = Teacher.statuses[teacher.course]
    teacher.more_info = teacher.other
    if teacher.status.nil?
      teacher.more_info = teacher.course || teacher.other
      teacher.status = OTHER
    end
    teacher.save!
  end
end
