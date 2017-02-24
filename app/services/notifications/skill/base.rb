module Notifications
  module Skill
    class Base < ::Notifications::Base
      private

      def notifiable_type
        'DraftSkill'
      end
    end
  end
end
