namespace :users do

  task :user_auth_token => :environment do
    users = User.where("auth_token IS NULL")
    users.find_each(batch_size: 1000) do |user|
      begin
        user.auth_token = SecureRandom.urlsafe_base64
      end while User.exists?(:auth_token => user.auth_token)
      user.save
    end
  end

  task :import_facebook_friends, [:user_id] => :environment do |t, args|
    user = User.find(args[:user_id])

    if UserFacebookAccount.new(user).connected?
      FacebookFriendsWorker.perform_async(user.id)
    end
  end

  task :update_challenges_count_column => :environment do
    User.find_each(batch_size: 1000) do |user|
      user.challenges_count = user.challenges.count
      user.challenges_count = user.challenges_count + user.proposed_challenges.count
      user.save
    end
  end

end