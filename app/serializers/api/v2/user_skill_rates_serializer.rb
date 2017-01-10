module Api::V2
  class UserSkillRatesSerializer < ActiveModel::Serializer
    attributes :skill_rates

    def skill_rates
      user_skill_rates_mapped
    end

    private

    def user_skill_rates_mapped
      user_skill_rates.map do |skill_rate|
        skill = skill_rate.skill
        {
          ref_name: skill.ref_name,
          rate: skill_rate.rate
        }
      end
    end

    def user_skill_rates
      object.user_skill_rates.includes(:skill)
    end
  end
end
