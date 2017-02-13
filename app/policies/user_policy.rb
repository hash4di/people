class UserPolicy < BasePolicy
  attr_reader :current_user, :user

  def initialize(current_user, user)
    @current_user = current_user
    @user = user
  end

  def history?
    return true if self? || talent?
    return false unless leader?

    users = Team.find_by(user_id: current_user.id).users
    users.include? user
  end

  def position_access?
    admin? || talent? || leader?
  end

  private

  def self?
    current_user == user
  end
end
