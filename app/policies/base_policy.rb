class BasePolicy
  private

  def admin?
    @current_user.admin?
  end

  def talent?
    @current_user.talent?
  end

  def leader?
    @current_user.leader?
  end

  def from_management?
    admin? || talent? || leader?
  end
end
