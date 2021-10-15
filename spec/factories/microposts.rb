FactoryBot.define do
  factory :micropost do
    content { "micropost test" }
    created_at { 42.days.ago }
    association :user

    # factory :user_microposts do
    #   content {  Faker::Lorem.sentence(word_count: 5) }
    #   created_at { 10.minutes.ago }
    #   association :user
    # end
  

    trait :yesterday do
      content { "yesterday" }
      created_at { 1.day.ago }
    end

    trait :day_before_yesterday do
      content { "day_before_yesterday" }
      created_at { 2.days.ago }
    end

    trait :now do
      content { "now!" }
      created_at { Time.zone.now }
    end
  end
end
