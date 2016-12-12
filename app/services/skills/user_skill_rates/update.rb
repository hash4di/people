module Skills
  module UserSkillRates
    class Update
      def initialize(user_id:, skill_id:, rate:)
        @user_id = user_id
        @skill_id = skill_id
        @rate = rate
      end

      def call
        new_content = user_skill_rate.content.dup
        new_content.update(rate: rate)
      end

      private

      attr_reader :user_id, :skill_id, :rate

      def user_skill_rate
        @user_skill_rate ||= ::UserSkillRate.find_by(skill_id: skill_id, user_id: user_id)
      end
    end
  end
end
