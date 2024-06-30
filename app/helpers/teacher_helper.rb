# frozen_string_literal: true

module TeacherHelper
  SNAP_USER_PAGE = "https://snap.berkeley.edu/user?username="
  def snap_link(teacher)
    return "-" if ["N/A", "None", "", nil].include?(teacher.snap)
    link_to(teacher.snap, "#{SNAP_USER_PAGE}#{teacher.snap}", target: "_blank")
  end

  def ip_history_display(teacher)
    return "-" if teacher.ip_history.nil? || teacher.ip_history.empty?
    teacher.ip_history.to_sentence
  end
end
