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
    echonest_artist = EchonestArtist.new(artist.title)
    if echonest_artist.bio
      artist.bio = echonest_artist.bio.text[0..1000]
      artist.bio_read_more_link = echonest_artist.bio.url
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
    unless Artist.find_by_title(echonest_artist.name)
      e_artist = EchonestArtist.new(echonest_artist.name, 1)
      e_artist.save_artist_to_db
    end
  end
end

task :create_fake_artists_users => :environment do
  Artist.find_each(batch_size: 1000) do |artist|
    ArtistFakeUser.new(artist).create_fake_user
  end
end

task :close_open_and_expired_group_challenges => :environment do
  Challenge.only_groups.open.where('end_at <= ?', Time.now).find_each(batch_size: 1000) do |challenge|
    GroupChallengeClosure.new(challenge).close
  end
end

task :close_open_and_expired_challenges => :environment do
  Challenge.one_to_one.open.where('end_at <= ?', Time.now).find_each(batch_size: 1000) do |challenge|
    ChallengeClosure.new(challenge).close
  end
end

task :close_played_challenges => :environment do
  Challenge.one_to_one.open.finished.find_each(batch_size: 1000) do |challenge|
    ChallengeClosure.new(challenge).close
  end
end

task :remind_user_to_install_the_game => :environment do
  User.not_fake_user.
        where('created_at < ?', 10.minutes.ago).
        where('created_at > ?', 20.minutes.ago).
        where('installed_desktop_app IS NULL OR installed_desktop_app = 0').find_each(batch_size: 1000) do |user|
    MandrillTemplateEmailNotifier.remind_user_to_install_the_game_mandrill_template(user).deliver
  end
end

task :remind_user_to_play_songs => :environment do
  User.not_fake_user.
      joins('LEFT JOIN songscore ON songscore.user_id = users.id_user').
      where('songscore.id IS NULL').
      where(installed_desktop_app: 1).
      where('installed_desktop_app_at < ?', 10.minutes.ago).
      where('installed_desktop_app_at > ?', 20.minutes.ago).find_each(batch_size: 1000) do |user|
    MandrillTemplateEmailNotifier.remind_user_to_play_songs_mandrill_template(user).deliver
  end
end

task :remind_user_to_install_the_game => :environment do
  User.not_fake_user.where('created_at < ?', 10.minutes.ago).where('created_at > ?', 20.minutes.ago).find_each(batch_size: 1000) do |user|
    MandrillTemplateEmailNotifier.remind_user_to_install_the_game_mandrill_template(user).deliver
  end
end

task :improve_music_career_reminder => :environment do
  User.not_fake_user.joins(:song_scores).
        where('songscore.created_at < ?', 10.minutes.ago).
        where('songscore.created_at > ?', 12.minutes.ago).find_each(batch_size: 1000) do |user|
    MandrillTemplateEmailNotifier.improve_music_career_mandrill_template(user).deliver
  end
end


task :test_mandrill_template => :environment do
  MandrillTemplateEmailNotifier.test_mandrill_template(User.last).deliver
end

task :user_premium_subscription_mandrill_template => :environment do
  MandrillTemplateEmailNotifier.user_premium_subscription_mandrill_template(UserPremiumSubscription.last).deliver
end

task :remind_user_to_install_the_game_mandrill_template => :environment do
  MandrillTemplateEmailNotifier.remind_user_to_install_the_game_mandrill_template(User.find(5505)).deliver
end

task :remind_user_to_play_songs_mandrill_template => :environment do
  MandrillTemplateEmailNotifier.remind_user_to_play_songs_mandrill_template(User.find(5505)).deliver
end

task :improve_music_career_mandrill_template => :environment do
  MandrillTemplateEmailNotifier.improve_music_career_mandrill_template(User.find(5505)).deliver
end

