module SkillHelper
  def request_change_btn_class(skill)
    'disabled' if skill.requested_change.present?
  end

  def skill_label_class(skill)
    case skill.rate
    when 1
      if skill.rate_type == 'range'
        'skill-label--orange'
      else
        'skill-label--green'
      end
    when 2
      'skill-label--yellow'
    when 3
      'skill-label--green'
    end
  end
end
