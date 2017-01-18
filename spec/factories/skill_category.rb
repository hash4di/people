FactoryGirl.define do
  factory :skill_category do
    name { Faker::Color.color_name.gsub(' ', '_') }
  end
end
