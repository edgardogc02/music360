desc "This tasks are called by the Heroku scheduler add-on"

task :remind_challenged_users => :environment do
  RemindChallengedUsersWorker.perform_async
end

task :remind_challenger_users => :environment do
  RemindChallengerUsersWorker.perform_async
end

task :renew_user_premium_subscription => :environment do
  UserPremiumSubscription.about_to_expire(12).find_each(batch_size: 1000) do |user_premium_subscription|
    UserPremiumSubscriptionManager.new(user_premium_subscription).renew
  end
end
