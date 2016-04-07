FactoryGirl.define do
  factory :membership do
    starts_at { DateTime.now - 5.weeks }
    ends_at { DateTime.now + 1.month }
    user
    project
    role
    billable false

    factory :membership_without_ends_at do
      ends_at nil
    end

    factory :membership_billable do
      billable 1
    end

    trait :without_end do
      ends_at nil
    end

    trait :booked do
      booked true
      booked_at { DateTime.now }
    end

    trait :billable do
      billable true
    end

    trait :future do
      starts_at { DateTime.now + 1.month }
    end

    trait :booked_expired do
      booked true
      booked_at { DateTime.now - 8.days }
    end
  end
end
