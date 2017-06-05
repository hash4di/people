module Skills
  class UserSkillRatesGenerator
    def generate_all_for_user(user_id:)
      skills.each do |skill|
        generate_for_skill(skill_ids: skill.id, user_id: user_id)
      end

      # sync_with_salesforce(skill_ids: skills.map(&:id), user_ids: [user_id])
    end

    def generate_single_for_all_users(skill_id:)
      users.each do |user|
        generate_for_skill(skill_id: skill_id, user_id: user.id)

      end

      # sync_with_salesforce(skill_ids: [skill_id], user_ids: users.map(&:id))
    end

    private

    # def sync_with_salesforce(skill_ids:, user_ids:)
    #   Salesforce::Synchroniser::UserSkillRates.new.upsert(
    #     skill_ids: skill_ids,
    #     user_ids: user_ids
    #   )
    # end

    def generate_for_skill(skill_id:, user_id:)
      ::Skills::UserSkillRates::Create.new(
        user_id: user_id, skill_id: skill_id
      ).call
    end

    def skills
      @skills ||= Skill.all
    end

    def users
      @users ||= User.active
    end
  end
end
