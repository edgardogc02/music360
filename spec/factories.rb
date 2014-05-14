FactoryGirl.define do
  factory :user, aliases: [:followed, :follower, :challenger, :challenged] do
    sequence(:username) { |n| "testuser#{n}" }
    password "12345"
    password_confirmation { "#{password}" }
    sequence(:email) { |n| "user#{n}@test.com" }
    skip_emails true
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
    onclient 1
    published_at Date.today
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

  factory :instrument do
    sequence(:name) { |n| "instrument#{n}" }
    visible 1
  end

  factory :user_invitation do
    user
    friend_email "test@test.com"
  end

end