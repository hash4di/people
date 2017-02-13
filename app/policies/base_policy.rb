class BasePolicy
  private

  def talent?
    @current_user.talent?
  end

  def leader?
    @current_user.leader?
  end
end
