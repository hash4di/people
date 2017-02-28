class UserPolicy
  attr_reader :current_user, :user

  def initialize(current_user, user)
    @current_user = current_user
    @user = user
  end

  def history?
    return true if self? || talent? || admin?
    return false unless leader?

    users = Team.find_by(user_id: current_user.id).users
    users.include? user
  end

  def skill_access?
    admin? || talent? || leader?
  end

  private

  def self?
    current_user == user
  end

  def admin?
    current_user.admin?
  end

  def talent?
    current_user.talent?
  end

  def leader?
    current_user.leader?
  end
end
