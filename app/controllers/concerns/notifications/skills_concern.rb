module Notifications
  module SkillsConcern
    extend ActiveSupport::Concern

    included do
      expose(:user_skill_rate) { fetch_user_skill_rate }
      expose(:last_notification) { fetch_last_notification }
      expose(:last_accepted_change) { fetch_last_change }

      private

      def fetch_user_skill_rate
        UserSkillRatesQuery.new(current_user).results_for_skill(
          skill_id: notifiable_id
        )
      end

      def notifiable_id
        return notification.notifiable.skill.id if notification.skill?
        notification.notifiable.id
      end

      def fetch_last_notification
        Notification.last_notification(current_user.id, last_accepted_change.id)
      end

      def fetch_last_change
        DraftSkill.last_accepted(notification.notifiable.skill.id)
      end
    end
  end
end
