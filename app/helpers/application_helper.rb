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
      "Schools": schools_path,
      "Teachers": teachers_path,
      "Email Templates": email_templates_path
    }
  end

  def check_or_x(bool)
    return "✔️" if bool

    "❌"
  end
end
