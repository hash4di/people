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
          user_skill_rates: { skill_id: skill_id }
        ).where.not(
          user_skill_rates: { rate: 0 }
        )
      end

      def skill_id
        @skill_id ||= DraftSkill.where(
          id: notifiable_id
        ).select('skill_id').first.skill_id
      end
    end
  end
end
