module Skills
  module UserSkillRates
    class Create
      def initialize(user_id:, skill_id:)
        @user_id = user_id
        @skill_id = skill_id
      end

      def call
        create_user_skill_rate
        create_user_skill_rate_content
        user_skill_rate
      end

      private

      def create_user_skill_rate
        @user_skill_rate ||= ::UserSkillRate.create(
          user_id: user_id, skill_id: skill_id
        )
      end

      def create_user_skill_rate_content
        user_skill_rate.contents.create(user_skill_rate_content_params)
      end

      def user_skill_rate_content_params
        user_skill_rate.attributes.slice('rate', 'note', 'favorite')
      end

      attr_reader :user_id, :skill_id, :user_skill_rate
    end
  end
end
