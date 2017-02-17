class Notification < ActiveRecord::Base
  belongs_to :notifiable, polymorphic: true
  belongs_to :receiver, foreign_key: 'receiver_id', class_name: 'User'

  STATUSES = %w(notified unread).freeze
  TYPES = %w(skill_updated skill_created).freeze

  validates :notification_type, inclusion: { in: TYPES }
  validates :notification_status, inclusion: { in: STATUSES }

  scope :unread, -> do
    where(notification_status: 'unread').order(created_at: :desc)
  end
  scope :since_last_30_days, -> do
    where('created_at > ?', Time.now - 30.days).order(created_at: :desc)
  end

  def notified?
    notification_status == 'notified'
  end
end
