# frozen_string_literal: true

module TeacherHelper

  SNAP_USER_PAGE = 'https://snap.berkeley.edu/user?user='
  def snap_link(teacher)
    return '-' if ['N/A', 'None', '', nil].include?(teacher.snap)
    link_to(teacher.snap, "#{SNAP_USER_PAGE}#{teacher.snap}", target: '_blank')
  end
end
