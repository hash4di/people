FactoryGirl.define do
  factory :user_skill_rate do
    user
    skill
  end

  trait :with_content do
    after(:create) do |user_skill_rate|
      user_skill_rate.contents << FactoryGirl.create(
        :user_skill_rate_content,
        user_skill_rate: user_skill_rate
      )
    end
  end
end
