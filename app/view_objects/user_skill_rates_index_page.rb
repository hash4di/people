class UserSkillRatesIndexPage
  def initialize(user:)
    @user = user
  end

  def initial_skill_category(skill_category_name)
    return 'js-initial-skill-category' if user_skill_category == skill_category_name.downcase
  end

  private

  def user_skill_category
    @user_skill_category ||= @user.primary_role.skill_category.name.downcase
  end
end
