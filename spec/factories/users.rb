FactoryBot.define do
  factory :user do
    name                  { "Example User" }
    sequence(:email)      { |n| "user#{n}@example.com" }
    password              { "foobar" }
    password_confirmation { "foobar" }
    activated             { true }
    activated_at          { Time.zone.now }
  end
  
  trait :other_user do
    name                  { Faker::Name.name }
    sequence(:email)      { |n| "test#{n}@example.com" }
    password              { "password"}
    password_confirmation { "password"}
    activated             { true }
    activated_at          { Time.zone.now }
  end

  trait :admin do
    name                  { "admin" } 
    email                 { "admin@example.com" }
    password              { "password"}
    password_confirmation { "password"}
    admin                 { true }
    activated             { true }
    activated_at          { Time.zone.now }
  end
  
  trait :no_admin do
    name                  { "no_admin" } 
    email                 { "no-admin@example.gov" }
    password              { "password"}
    password_confirmation { "password"}
    activated             { true }
    activated_at          { Time.zone.now }
  end

  trait :michael do
    name                  { "Michael Example" } 
    email                 { "michael@example.com" }
    password              { "password"}
    password_confirmation { "password"}
    admin                 { true }
    activated             { true }
    activated_at          { Time.zone.now }

  end


  trait :no_activated do
    activated { false }
    activated_at { nil }
  end

  trait :with_microposts do
    after(:create) { |user| create_list(:micropost, 5, user: user) }
  end


end



 