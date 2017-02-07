class UserSkillRatesIndexPage
  NO_PRIMARY_ROLE = :no_primary_role

  def initialize(user:)
    @user = user
  end

  def initial_skill_category(skill)
    puts(user_skill_category)
    return 'js-initial-skill-category' if user_skill_category == skill
  end

  private

  def user_skill_category
    @user_skill_category ||= @user.primary_role&.skill_category ||
                             @user.primary_roles.first ||
                             NO_PRIMARY_ROLE
  end
end
