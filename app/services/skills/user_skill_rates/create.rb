module Skills
  module UserSkillRates
    class Create
      def initialize(user_id:, skill_id:, rate:)
        @user_id = user_id
        @skill_id = skill_id
        @rate = rate
      end

      def call
        user_skill_rate = ::UserSkillRate.create(user_id: user_id, skill_id: skill_id)
        user_skill_rate.contents.create(rate: rate)
        user_skill_rate
      end

      private

      attr_reader :user_id, :skill_id, :rate
    end
  end
end
