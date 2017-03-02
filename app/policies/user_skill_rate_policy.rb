class UserSkillRatePolicy
  attr_reader :current_user, :user_skill_rate

  def initialize(current_user, user_skill_rate)
    @current_user = current_user
    @user_skill_rate = user_skill_rate
  end

  def update?
    user_skill_rate.user == current_user
  end
end
