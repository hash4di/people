module Api::V2
  class UserSkillRatesSerializer < ActiveModel::Serializer
    attributes :user_with_skill_rates

    def user_with_skill_rates
      rates_mapped = user_skill_rates_mapped(user_skill_rates)
      return if rates_mapped.empty?

      Hash[object.email, rates_mapped]
    end

    private

    def user_skill_rates_mapped(rates)
      rates.map do |user_rate|
        skill = user_rate.skill
        category = skill.skill_category

        {
          category: category.name,
          ref_name: skill.ref_name,
          rate: user_rate.rate
        }
      end
    end

    def user_skill_rates
      object.user_skill_rates.includes(skill: :skill_category)
    end
  end
end
