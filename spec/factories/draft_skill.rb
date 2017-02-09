FactoryGirl.define do
  factory :draft_skill do
    skill_category
    skill
    draft_type 'update'
    draft_status 'created'
    requester_explanation { Faker::Lorem.paragraph }

    trait :with_crete_draft_type do
      draft_type 'create'
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
