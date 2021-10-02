FactoryBot.define do
  factory :user do
    name                  { "Example User" }
    email                 { "user@example.com" }
    password              { "foobar" }
    password_confirmation { "foobar" }
  end

  trait :michael do
    name                  { "Michael Example" } 
    email                 { "michael@example.com" }
    password              { "password"}
    password_confirmation { "password"}
    # password_digest       { User.digest('password')}
  end
end