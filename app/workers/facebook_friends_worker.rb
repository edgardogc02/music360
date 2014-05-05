class FacebookFriendsWorker
  include Sidekiq::Worker

  def perform(user_id)
    user = User.find(user_id)
    if user.has_facebook_credentials?
      UserFacebookFriends.new(user, user.facebook_top_friends).save
    end
  end
end