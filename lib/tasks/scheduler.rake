desc "This tasks are called by the Heroku scheduler add-on"

task :remind_challenged_users => :environment do
  RemindChallengedUsersWorker.perform_async
end

task :remind_challenger_users => :environment do
  RemindChallengerUsersWorker.perform_async
end

task :renew_user_premium_subscription => :environment do
  UserPremiumSubscription.about_to_expire_in_hours(12).find_each(batch_size: 1000) do |user_premium_subscription|
    UserPremiumSubscriptionManager.new(user_premium_subscription).renew
  end
end

task :user_premium_subscription_alert_renewal => :environment do
  UserPremiumSubscription.about_to_expire_in_hours(24).find_each(batch_size: 1000) do |user_premium_subscription|
    UserPremiumSubscriptionManager.new(user_premium_subscription).renewal_alert
  end
end

task :download_artist_bio => :environment do
  Artist.find_each(batch_size: 1000) do |artist|
    bio_from_echonest = artist.bio_from_echonest
    if bio_from_echonest
      artist.bio = artist.bio_from_echonest.text
      artist.bio_read_more_link = artist.bio_from_echonest.url
    end

    artist.save
  end
end

task :download_artist_images => :environment do
  Artist.find_each(batch_size: 1000) do |artist|
    artist.download_echonest_image
  end
end

task :save_top_artists_from_echonest => :environment do
  Artist.top_from_echonest(12).each do |echonest_artist|
    artist = Artist.find_by_title(echonest_artist.name)

    artist = Artist.create(title: echonest_artist.name, top: 1) unless artist

    if !echonest_artist.images.blank?
      artist.remote_imagename_url = echonest_artist.images.first.url
    end

    bio_from_echonest = artist.bio_from_echonest
    if bio_from_echonest
      artist.bio = artist.bio_from_echonest.text
      artist.bio_read_more_link = artist.bio_from_echonest.url
    end

    artist.save
  end
end

task :test_mandrill_template => :environment do
  MandrillTemplateEmailNotifier.test_mandrill_template(User.last).deliver
end
