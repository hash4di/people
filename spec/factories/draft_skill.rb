FactoryGirl.define do
  factory :draft_skill do
    skill_category
    name { Faker::Name.name }
    description { Faker::Lorem.paragraph }
    skill
    draft_type 'update'
    draft_status 'created'
    requester_explanation { Faker::Lorem.paragraph }
    requester { create(:user) }
    rate_type { %w(boolean range).sample }

    trait :with_create_draft_type do
      draft_type 'create'
      skill nil
    end

    trait :with_update_draft_type do
      draft_type 'update'
    end

    trait :with_declined_draft_status do
      draft_status 'declined'
    end

    trait :with_accepted_draft_status do
      draft_status 'accepted'
    end

    trait :with_created_draft_status do
      draft_status 'created'
    end
  end
end
