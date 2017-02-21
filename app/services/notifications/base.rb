module Notifications
  class Base
    class NotificationTypeNotFound < StandardError; end
    class NotifiableTypeNotFound < StandardError; end
    class ReceiversNotFound < StandardError; end
    class UnexpectedStatusType < StandardError; end
    class UnexpectedType < StandardError; end

    attr_reader :notifiable_id

    NOTIFICATION_STATUS = 'unread'.freeze

    def initialize(notifiable_id:)
      @notifiable_id = notifiable_id
    end

    def notify
      validate_notification_status
      validate_notification_type
      create_notifications
    end

    private

    def create_notifications
      receivers.each do |receiver|
        receiver.notifications.create(notification_attributes)
      end
    end

    def notification_attributes
      @notification_attributes ||= {
        notification_status: notification_status,
        notification_type: notification_type,
        notifiable_id: notifiable_id,
        notifiable_type: notifiable_type,
      }
    end

    def notification_status
      NOTIFICATION_STATUS
    end

    def notification_type
      fail NotificationTypeNotFound, 'Please define notification_type method to your notification service'
    end

    def notifiable_type
      fail NotifiableTypeNotFound, 'Please define notifiable_type method to your notification service'
    end

    def receivers
      fail ReceiversNotFound, 'Please define receivers method to your notification service'
    end

    def validate_notification_status
      unless Notification::STATUSES.include? notification_status
        fail UnexpectedStatusType, "Notifications status: #{notification_status} is not allowed. Allowed statuses: #{Notification::STATUSES}"
      end
    end

    def validate_notification_type
      unless Notification::TYPES.include? notification_type
        fail UnexpectedType, "Notifications type: #{notification_type} is not allowed. Allowed statuses: #{Notification::TYPES}"
      end
    end
  end
end
