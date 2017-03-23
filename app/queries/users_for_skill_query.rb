class UsersForSkillQuery
  attr_reader :skill, :user, :team

  def initialize(skill:, user:)
    @skill = skill
    @user = user
  end

  def results
    skill.user_skill_rates.joins(user: :primary_role).where(
      'user_id IN (?)', query_scope
    ).select(selected_fields).order(rate: :desc,favorite: :desc)
  end

  private

  def selected_fields
    "
      user_skill_rates.id as user_skill_rate_id,
      rate,
      favorite,
      user_skill_rates.user_id,
      users.first_name,
      users.last_name,
      roles.name as role_name
    "
  end

  def query_scope
    if user_is_admin_or_talent
      User.technical.active.pluck(:id)
    elsif user_has_team?
      team.users.pluck(:id)
    end
  end

  def user_is_admin_or_talent
    user.admin? || user.talent?
  end

  def user_has_team?
    @team ||= Team.where(user_id: user.id).first
    @team.present?
  end
end
