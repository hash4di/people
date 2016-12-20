module Skills
  module UserSkillRates
    class Update
      def initialize(user_skill_rate_id:, params:)
        @user_skill_rate_id = user_skill_rate_id
        @params = params
      end

      def call
        update_user_skill_rate
        create_new_user_skill_rate_content
        user_skill_rate
      end

      private

      attr_reader :user_skill_rate_id, :params

      def update_user_skill_rate
        user_skill_rate.update_attributes(params)
      end

      def create_new_user_skill_rate_content
        user_skill_rate.contents.create(params)
      end

      def user_skill_rate
        @user_skill_rate ||= ::UserSkillRate.find(user_skill_rate_id)
      end
    end
  end
end
