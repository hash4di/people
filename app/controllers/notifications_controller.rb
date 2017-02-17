class NotificationsController < ApplicationController
  before_filter :authenticate_for_skills!
  expose(:grouped_notifications_by_type) { fetch_all_notifications }
  expose(:notification) { fetch_notification }
  expose(:user_skill_rate) { fetch_user_skill_rate }

  def update
    authorize notification
    respond_to do |format|
      if notification.update(notification_params)
        format.html { redirect_to redirect_update_path, notice: 'notification marked as notified.' }
        format.json { head :no_content }
      else
        format.html { redirect redirect_update_path, error: 'Unexpected error occured. notification is not marked as notified.' }
        format.json { render json: notification.errors, status: :unprocessable_entity }
      end
    end
  end

  def index; end

  def show
    authorize notification
  end

  private

  def redirect_update_path
    case notification.notification_type
    when 'skill_created', 'skill_updated'
      notification_path(id: notification.notifiable_id)
    end
  end

  def notification_params
    @notification_params ||= params.require(
      :notification
    ).permit(:notification_status)
  end

  def fetch_all_notifications
    NotificationDecorator.decorate_collection(
      Notification.includes(:notifiable).since_last_30_days.where(receiver_id: current_user.id)
    ).group_by(&:notification_type)
  end

  def fetch_notification
    NotificationDecorator.new(Notification.find(params[:id]))
  end

  def fetch_user_skill_rate
    UserSkillRatesQuery.new(current_user).results_for_skill(
      skill_id: notification.notifiable.id
    )
  end
end
