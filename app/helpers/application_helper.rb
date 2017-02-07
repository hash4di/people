module ApplicationHelper
  def api_link(link)
    return unless link
    link_to 'Link', link
  end

  def simple_date(date)
    return unless date
    date.sub(/T.*/, '')
  end

  def bool_to_glyph(value)
    value ? 'ok' : 'remove'
  end

  def menu_class(name)
    'active' if name == controller_name
  end

  def project_type_class(names)
    [names, ('selected' if names.include?(action_name))]
  end

  def body_css_classes
    "#{controller_path.gsub('/', ' ')} #{action_name}"
  end

  def backbone_view
    [controller_name, action_name].map(&:camelcase).join
  end

  def bootstrap_flash
    flash_msg = ""
    flash.each do |name, msg|
      flash_msg << "
        <div class='alert alert-#{get_alert_class name} alert-dismissable'>
          <button type='button' class='close' data-dismiss='alert' aria-hidden='true'>&times;</button>
          #{msg}
        </div>" if msg.is_a? String
    end
    raw flash_msg
  end

  def icon(name, options = {})
    icon_generator(name, 'fa fa', options)
  end

  def profile_link(user)
    link_to user.name, user_path(user)
  end

  def parameterize(text)
    text.parameterize('_')
  end

  def draft_skill_label_status_class(status)
    case status
    when 'created'
      'label-primary'
    when 'accepted'
      'label-success'
    when 'declined'
      'label-danger'
    end
  end

  def draft_skill_label_type_class(type)
    case type
    when 'update'
      'label-info'
    when 'create'
      'label-primary'
    end
  end

  private

  def icon_generator(name, icon_class, options = {})
    content_tag :i, nil, id: options[:id], class: "#{icon_class}-#{name} #{options[:class]}"
  end

  def get_alert_class(type)
    case type
    when :alert
      "warning"
    when :error
      "danger"
    else
      "success"
    end
  end
end
