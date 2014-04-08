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

  factory :category do
    sequence(:title) { |n| "category#{n}"}
  end

  factory :artist do
    sequence(:title) { |n| "title#{n}"}
    bio "This is the artist bio"
    country "USA"
    slug {"#{title}-slug"}
  end

  factory :song do
    category
    artist
    sequence(:title) { |n| "song#{n}"}
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

end