FactoryGirl.define do
  factory :notification do
    receiver { create(:user) }
    notification_status { %w(notified unread).sample }
    notification_type { %w(skill_updated skill_created).sample }
    notifiable { create(:skill) }

    trait :notified do
      notification_status 'notified'
    end

    trait :unread do
      notification_status 'unread'
    end
  end
end
