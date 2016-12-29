class UserSkillRatesFetcher
  attr_reader :user

  def initialize(user_id)
    @user = User.find(user_id)
  end

  def call
    user_with_skill_rates_hash
  end

  private

  def user_with_skill_rates_hash
    rates_mapped = user_skill_rates_mapped(user_skill_rates)
    return if rates_mapped.empty?

    Hash[user.email, rates_mapped]
  end

  def user_skill_rates_mapped(rates)
    rates.map do |user_rate|
      skill = user_rate.skill
      category = skill.skill_category

      Array[category.name, skill.ref_name, user_rate.rate]
    end
  end

  def user_skill_rates
    user.user_skill_rates.includes(skill: :skill_category)
  end
end
