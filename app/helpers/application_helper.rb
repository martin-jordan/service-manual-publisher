module ApplicationHelper
  def alert_css_class(flash_type)
    {
      notice: 'alert-success',
      alert: 'alert-warning',
      error: 'alert-danger'
    }[flash_type.to_sym]
  end

  def disable_if_new_record(record)
    if record.new_record?
      { disable: true }
    else
      {}
    end
  end

  def css_class_if_current(path, class_name)
    if current_page?(path)
      class_name
    end
  end

  def name_for_user(user)
    user.name
  end

  def user_options
    User.pluck(:name, :id)
  end

  def author_options
    User.authors.pluck(:name, :id)
  end
end
