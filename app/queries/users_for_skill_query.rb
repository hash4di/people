class UsersForSkillQuery
  attr_reader :skill

  def initialize(skill:)
    @skill = skill
  end

  def results
    skill.user_skill_rates.joins(:user).select(selected_fields).order(
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
end
