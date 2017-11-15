include ActionView::Helpers::DateHelper

class DraftSkillDecorator < Draper::Decorator
  decorates_association :requester
  decorates_association :reviewer
  delegate_all

  def humanized_request_time
    "#{distance_of_time_in_words(object.created_at, Time.now)} ago"
  end

  def humanized_review_time
    return '' unless object.resolved?
    "#{distance_of_time_in_words(object.created_at, Time.now)} ago"
  end

  def label_status_class
    case object.draft_status
    when 'created'
      'label-primary'
    when 'accepted'
      'label-success'
    when 'declined'
      'label-danger'
    end
  end

  def label_type_class
    case object.draft_type
    when 'update'
      'label-info'
    when 'create'
      'label-primary'
    when 'delete'
      'label-danger'
    end
  end
end
