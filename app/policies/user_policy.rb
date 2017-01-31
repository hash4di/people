class UserPolicy
  attr_reader :current_user, :user

  def initialize(current_user, user)
    @current_user = current_user
    @user = user
  end

  def display_skills?
    return true if current_user.talent?
    return false unless current_user.leader?

    users = Team.find_by(user_id: current_user.id).users
    users.include? user
  end
end
