module Skills
  class UserSkillRatesGenerator

    attr_reader :user_id

    def initialize(user_id:)
      @user_id = user_id
    end

    def call
      generate_default_user_skills
    end

    private

    def generate_default_user_skills
      skills.each do |skill|
        ::Skills::UserSkillRates::Create.new(
          user_id: user.id, skill_id: skill.id
        ).call
      end
    end

    def skills
      @skills ||= Skill.all
    end

    def user
      @user ||= User.find(user_id)
    end
  end
end
