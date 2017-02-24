module Notifications
  module SkillsConcern
    extend ActiveSupport::Concern

    included do
      expose(:user_skill_rate) { fetch_user_skill_rate }

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
    end
  end
end
