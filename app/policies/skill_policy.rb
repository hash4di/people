class SkillPolicy
  attr_reader :current_user, :skill

  def initialize(current_user, skill)
    @current_user = current_user
    @skill = skill
  end

  def edit?
    !has_requested_change?
  end

  private

  def has_requested_change?
    skill.requested_change.present?
  end
end
