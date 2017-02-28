class Notification < ActiveRecord::Base
  belongs_to :notifiable, polymorphic: true
  belongs_to :receiver, foreign_key: 'receiver_id', class_name: 'User'

  STATUSES = %w(notified unread).freeze
  SKILL_TYPES = %w(skill_updated skill_created).freeze
  TYPES = SKILL_TYPES

  validates :notification_type, inclusion: { in: TYPES }
  validates :notification_status, inclusion: { in: STATUSES }

  scope :unread, -> do
    where(notification_status: 'unread').order(created_at: :desc)
  end
  scope :since_last_30_days, -> do
    where('created_at > ?', Time.now - 30.days).order(created_at: :desc)
  end
  scope :last_notification, -> (receiver_id, notifiable_id) {
    where(receiver_id: receiver_id, notifiable_id: notifiable_id).last
  }

  def skill?
    SKILL_TYPES.include? notification_type
  end

  def notified?
    notification_status == 'notified'
  end

  def skill_created?
    notification_type == 'skill_created'
  end

  def skill_updated?
    notification_type == 'skill_updated'
  end
end
