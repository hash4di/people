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
        UserSkillRate.find_or_create_by(
          user_id: user.id, skill_id: skill.id
        )
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
