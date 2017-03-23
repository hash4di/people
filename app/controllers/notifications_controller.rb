class NotificationsController < ApplicationController
  include Notifications::SkillsConcern
  expose(:grouped_notifications_by_type) { fetch_all_notifications }
  expose(:notification) { fetch_notification }

  def update
    authorize notification
    respond_to do |format|
      if notification.update(notification_params)
        format.html { redirect_to notification_path(notification.id) }
        format.json { head :no_content }
      else
        format.html { redirect notification_path(notification.id), error: 'Unexpected error occured. notification is not marked as notified.' }
        format.json { render json: notification.errors, status: :unprocessable_entity }
      end
    end
  end

  def index; end

  def show
    authorize notification
  end

  private

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
end
