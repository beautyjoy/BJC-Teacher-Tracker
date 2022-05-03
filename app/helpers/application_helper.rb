# frozen_string_literal: true

module ApplicationHelper
  def alert_class(name)
    case name
    when "alert"
      "danger"
    when "notice"
      "info"
    else
      name
    end
  end

  def admin_nav_links
    {
      "Dashboard": dashboard_path,
      "All Schools": schools_path,
      "All Teachers": teachers_path,
      "Email Templates": email_templates_path
    }
  end
end
