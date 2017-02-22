module Notifications
  module Skill
    class Base < ::Notifications::Base
      private

      def notifiable_type
        'Skill'
      end
    end
  end
end
