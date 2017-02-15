class DraftSkillPolicy
  attr_reader :current_user, :draft_skill

  def initialize(current_user, draft_skill)
    @current_user = current_user
    @draft_skill = draft_skill
  end

  def allowed_to_modify?
    !requester?
  end

  private

  def requester?
    draft_skill.requester == current_user
  end
end
