FactoryGirl.define do
  factory :user_skill_rate_content, class: ::UserSkillRate::Content do
    user_skill_rate
    rate 2
    note { Faker::Lorem.sentence }
    favorite false

    trait :with_boolean_rate_type do
      after(:build) do |content|
        skill = build(:skill, :with_boolean_rate_type)
        user_skill_rate = build(:user_skill_rate, skill: skill)
        content.user_skill_rate = user_skill_rate
      end
    end

    trait :with_range_rate_type do
      after(:build) do |content|
        skill = build(:skill, :with_range_rate_type)
        user_skill_rate = build(:user_skill_rate, skill: skill)
        content.user_skill_rate = user_skill_rate
      end
    end
  end
end
