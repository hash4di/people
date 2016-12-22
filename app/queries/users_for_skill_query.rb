class UsersForSkillQuery
  attr_reader :skill, :user, :team

  def initialize(skill:, user:)
    @skill = skill
    @user = user
  end

  def results
    skill.user_skill_rates.joins(:user).where(
      'user_id IN (?)', query_scope
    ).select(
      selected_fields
    ).order(
      rate: :desc,
      favorite: :desc
    )
  end

  private

  def selected_fields
    "
      user_skill_rates.id as user_skill_rate_id,
      rate,
      favorite,
      user_id,
      users.first_name as first_name,
      users.last_name as last_name
    "
  end

  def query_scope
    if user_has_team?
      team.users.pluck(:id)
    else
      '*'
    end
  end

  def user_has_team?
    @team ||= Team.where(user_id: user.id).first
    @team.present?
  end
end
