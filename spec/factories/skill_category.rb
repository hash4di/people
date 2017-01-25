FactoryGirl.define do
  factory :skill_category do
    name { Faker::Name.name.delete(' ') }
  end
end
