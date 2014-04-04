FactoryGirl.define do
  factory :user, aliases: [:followed, :follower] do
    sequence(:username) { |n| "testuser#{n}"}
    password "12345"
    password_confirmation { "#{password}" }
    email { "#{username}@test.com" }
  end

  factory :user_follower do
    followed
    follower
  end

end