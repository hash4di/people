module Notifications
  module Skill
    class Updated < ::Notifications::Skill::Base
      private

      def notification_type
        'skill_updated'
      end

      def receivers
        @receivers ||= User.joins(
          :user_skill_rates
        ).where(
          user_skill_rates: { skill_id: notifiable_id}
        ).where.not(
          user_skill_rates: { rate: 0 }
        )
      end
    end
  end
end
