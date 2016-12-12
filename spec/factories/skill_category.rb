FactoryGirl.define do
  factory :skill_category do
    name { %w(backend devops frontend ios design android).sample }
  end
end
