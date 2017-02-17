class NotificationPolicy
  attr_reader :current_user, :notification

  def initialize(current_user, notification)
    @current_user = current_user
    @notification = notification
  end

  def update?
    owner?
  end

  def show?
    owner?
  end

  private

  def owner?
    notification.receiver == current_user
  end
end
