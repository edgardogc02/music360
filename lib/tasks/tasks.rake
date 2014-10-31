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

  task :create_premium_plan_as_gifts => :environment do
    PremiumPlanAsGift.delete_all
    PremiumPlanAsGift.create!(price: 5.99, name: "1 Month Subscription", display_position: 1, duration_in_months: 1, currency: "EUR")
    PremiumPlanAsGift.create!(price: 15.99, name: "3 Months Subscription", display_position: 2, duration_in_months: 3, currency: "EUR")
    PremiumPlanAsGift.create!(price: 59.99, name: "12 Months Subscription", display_position: 3, duration_in_months: 12, currency: "EUR")
  end

end