include ActionView::Helpers::DateHelper

class NotificationDecorator < Draper::Decorator
  decorates_association :requester
  delegate_all

  def icon_class
    case object.notification_type
    when 'skill_created'
      'glyphicon-plus'
    when 'skill_updated'
      'glyphicon-pencil'
    end
  end

  def message
    I18n.t(
      "notifications.#{object.notification_type}",
      notifiable_name: notifiable_name
    )
  end

  def humanized_sent_time
    "#{distance_of_time_in_words(object.created_at, Time.now)} ago"
  end

  def humanized_notified_time
    return '' unless object.notified?
    "#{distance_of_time_in_words(object.updated_at, Time.now)} ago"
  end

  private

  def notifiable_name
    if object.skill?
      object.notifiable.original_skill_details.name || object.notifiable.name
    else
      object.notifiable.name
    end
  end
end
