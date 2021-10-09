FactoryBot.define do
  factory :user do
    name                  { "Example User" }
    email                 { "user@example.com" }
    password              { "foobar" }
    password_confirmation { "foobar" }
    
    factory :other_user do
      name { Faker::Name.name }
      email { Faker::Internet.email }
    end
  end

  trait :michael do
    name                  { "Michael Example" } 
    email                 { "michael@example.com" }
    password              { "password"}
    password_confirmation { "password"}
    admin                 { true }
  end

  trait :archer do
    name                  { "Sterling Archer" } 
    email                 { "duchess@example.gov" }
    password              { "password"}
    password_confirmation { "password"}
  end
end
  # trait :lana do
  #   name                  { "Lana Kane" } 
  #   email                 { "hands@example.gov" }
  #   password              { "password"}
  #   password_confirmation { "password"}
  # end

  # trait :malory do
  #   name                  { "Malory Archer" } 
  #   email                 { "boss@example.gov" }
  #   password              { "password"}
  #   password_confirmation { "password"}
  # end

  # trait :test_data do
  #   name                  { "test_data" } 
  #   email                 { "test@example.gov" }
  #   password              { "password"}
  #   password_confirmation { "password"}
  # end


 