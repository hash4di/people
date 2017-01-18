FactoryGirl.define do
  factory :skill do
    ref_name { Faker::Name.name }
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
  end
end
