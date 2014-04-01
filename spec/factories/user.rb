FactoryGirl.define do
  factory :user do
    sequence(:username) { |n| "testuser#{n}"}
    password "12345"
    password_confirmation { "#{password}" }
    email { "#{username}@test.com" }
  end
end