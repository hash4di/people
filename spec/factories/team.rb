FactoryGirl.define do
  factory :team do
    name { Faker::Name.name }

    factory :team_with_members
      transient do
        users_count 8
      end

      after(:create) do |team, evaluator|
        create_list(:user, evaluator.users_count, teams: [team])
      end
  end
end
