class PositionPolicy < BasePolicy
  attr_reader :current_user, :user, :position

  def initialize(current_user, position)
    @current_user = current_user
    @user = position.user
    @position = position
  end

  def create?
    leader_or_talent?
  end

  def update?
    leader_or_talent?
  end

  def destroy?
    leader_or_talent?
  end

  def toggle_primary?
    leader_or_talent?
  end

  private

  def leader_or_talent?
    return true if talent? || admin?
    return false unless leader?

    users = Team.include(:users).find_by(user_id: current_user.id).users
    users.include? user
  end
end
