FactoryGirl.define do
  factory :user, aliases: [:followed, :follower, :challenger, :challenged, :initiator_user, :publisher] do
    sequence(:username) { |n| "testuser#{n}" }
    password "12345"
    password_confirmation { "#{password}" }
    sequence(:email) { |n| "user#{n}@test.com" }
    skip_emails true
    created_by "localhost"
    challenges_count 0

    factory :admin do
      admin 1
    end

    factory :premium_user do
      premium 1
      premium_until 1.months.from_now
    end
  end

  factory :user_follower do
    followed
    follower
  end

  factory :user_omniauth_credential do
    user
    provider "facebook"
    sequence(:oauth_uid) { |n| "1234567890#{n}" }
    sequence(:username) { |n| "testuser#{n}" }
    sequence(:email) { |n| "user#{n}@test.com" }
    oauth_token "dhashdajkdhjashdajdhakdhahdsai"
  end

  factory :category do
    sequence(:title) { |n| "category#{n}" }
  end

  factory :artist do
    sequence(:title) { |n| "title#{n}" }
    bio "This is the artist bio"
    country "USA"
    slug {"#{title}-slug"}
  end

  factory :song do
    category
    artist
    sequence(:title) { |n| "song#{n}" }
    cover "song-cover"
    writer "song-writer"
    length "5"
    difficulty 4
    arranger_userid 1
    comment "comment"
    status "status"
    cost 0
    published_at Date.today

    factory :paid_song do
      cost 10
    end
  end

  factory :song_rating do
    user
    song
    rating 5
  end

  factory :challenge do
    challenger
    challenged
    song
    public false
    instrument "Guitar"
    score_u1 0
    score_u2 0
  end

  factory :group_challenge, class: Challenge do
    challenger
    song
    public false
    instrument "Guitar"
    score_u1 0
    score_u2 0
    group
  end

  factory :instrument do
    sequence(:name) { |n| "instrument#{n}" }
    visible 1
  end

  factory :user_invitation do
    user
    friend_email "test@test.com"
  end

  factory :user_purchased_song do
    user
    song
  end

  factory :payment_method do
    sequence(:name) { |n| "payment_method#{n}" }
    display_position 1
    sequence(:html_id) { |n| "select_payment_method_#{n}" }
  end

  factory :payment do
    amount 14.50
    status "Confirmed"
    user
    payment_method
  end

  factory :premium_plan do
    price 9.99
    sequence(:name) { |n| "plan_#{n}" }
    duration_in_months 1
    currency "EUR"
  end

  factory :user_premium_subscription do
    user
    premium_plan
    payment
  end

  factory :level do
    sequence(:title) { |n| "level_#{n}" }
    xp 0
  end

  factory :group_privacy do
    name "Privacy"
    description "This will be a group with privacy"

    factory :public_group_privacy do
      name "Public"
    end
    factory :closed_group_privacy do
      name "Closed"
    end
    factory :secret_group_privacy do
      name "Secret"
    end
  end

  factory :group do
    sequence(:name) { |n| "Test Group #{n}" }
    initiator_user
    group_privacy
  end

  factory :user_group do
    user
    group
  end

  factory :group_invitation do
    user
    group
  end

  factory :group_post do
    group
    publisher
    sequence(:message) { |n| "Message nr #{n}"}
  end

end