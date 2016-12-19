class GroupUserSkillRatesBySkillCategoriesQuery
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def results
    user_skill_rates.group_by { |skill| skill.category }
  end

  private

  def user_skill_rates
    UserSkillRate.joins(
      skill: :skill_category
    ).select(select_fields).where(user_id: user.id)
  end

  def select_fields
    "
      user_skill_rates.*,
      skills.name as name,
      skills.description as description,
      skills.rate_type as rate_type,
      skill_categories.name as category
    "
  end
end
