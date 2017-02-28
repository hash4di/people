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

  def menu_class(name, namespace = nil)
    full_name = namespace.present? ? "#{namespace}/#{name}" : name
    return 'active' if full_name == controller_path
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

  private

  def icon_generator(name, icon_class, options = {})
    content_tag :i, nil, id: options[:id], class: "#{icon_class}-#{name} #{options[:class]}"
  end

  def get_alert_class(type)
    type = type.to_s
    case type
    when 'alert'
      "warning"
    when 'error'
      "danger"
    else
      "success"
    end
  end
end
