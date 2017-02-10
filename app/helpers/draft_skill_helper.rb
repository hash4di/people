module DraftSkillHelper
  def update_request_btn_class(draft_skill, user)
    'disabled' if draft_skill.requester == user
  end
end
