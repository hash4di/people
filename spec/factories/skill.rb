FactoryGirl.define do
  factory :skill do
    sequence(:name) { |num| Faker::Name.name + num.to_s }
    description { Faker::Lorem.paragraph }
    skill_category
    rate_type 'range'

    trait :with_range_rate_type do
      rate_type 'range'
    end

    trait :with_boolean_rate_type do
      rate_type 'boolean'
    end

    trait :with_awaiting_change_request do
      after(:create) do |skill|
        skill.draft_skills << FactoryGirl.create(
          :draft_skill,
          :with_created_draft_status,
          draft_type: 'update',
          skill: skill
        )
      end
    end

    trait :with_awaiting_create_request do
      after(:create) do |skill|
        skill.draft_skills << FactoryGirl.create(
          :draft_skill,
          :with_created_draft_status,
          draft_type: 'create',
          skill: skill
        )
      end
    end
    
    trait :with_awaiting_delete_request do
      marked_for_delete true
      after(:create) do |skill|
        skill.draft_skills << FactoryGirl.create(
          :draft_skill,
          :with_created_draft_status,
          draft_type: 'delete',
          skill: skill
        )
      end
    end

    trait :with_user_skill_rate do
      after(:create) do |skill|
        skill.user_skill_rates << FactoryGirl.create(
          :user_skill_rate,
          skill: skill
        )
      end
    end
  end
end
