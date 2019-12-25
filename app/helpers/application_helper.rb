module ApplicationHelper
  def alert_class(name)
    case name
    when 'alert'
      'danger'
    when 'notice'
      'info'
    else
      name
    end
  end
end
