module Notifications
  module Skill
    class Created < ::Notifications::Skill::Base
      private

      def notification_type
        'skill_created'
      end

      def receivers
        @receivers ||= User.active
      end
    end
  end
end
