module SkillHelper
  def request_change_btn_class(skill)
    'disabled' if skill.requested_change.present?
  end
end
