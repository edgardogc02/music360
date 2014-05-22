class FacebookFriendsWorker
  include Sidekiq::Worker

  def perform(user_id)
    user = User.find(user_id)
    user_facebook_account = UserFacebookAccount.new(user)
    if user_facebook_account.connected?
      UserFacebookFriends.new(user, user_facebook_account.top_friends).save
    end
  end
end