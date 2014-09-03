class PagesController < ApplicationController
  before_action :authorize, except: [:help]

  def home
    #users = User.not_deleted.exclude(current_user).search_user_relationships(current_user).limit(12) | User.not_deleted.exclude(current_user).limit(12)
    #@users = UserChallengeDecorator.decorate_collection(User.exclude(current_user.id).order_by_challenges_count.limit(12))

    users = User.exclude(current_user.id).order_by_challenges_count.limit(2) | User.not_deleted.exclude(current_user).search_user_relationships(current_user).limit(2) | User.not_deleted.exclude(current_user).limit(2)

    @users = UserChallengeDecorator.decorate_collection(users.take(4))
    @songs = SongQuickStartDecorator.decorate_collection(Song.not_user_created.free.by_popularity.limit(4))

    @instruments = Instrument.visible

    @top_songs = SongDecorator.decorate_collection(Song.by_popularity.limit(4))
    @top_users = UserChallengeDecorator.decorate_collection(User.order_by_challenges_count.exclude(current_user).limit(4))
    @top_artist = Artist.all.limit(4)

    if UserFacebookAccount.new(current_user).connected?
      @top_fb_friends = UserChallengeDecorator.decorate_collection(User.order_by_challenges_count.limit(4))
    end

    groups_feeds = PublicActivity::Activity.where(group_id: current_user.groups).order('created_at DESC').limit(10)

    one_to_one_challenge_feeds = PublicActivity::Activity.where(challenge_id: current_user.challenges).where(group_id: nil).order('created_at DESC').limit(10)

    one_to_one_proposed_challenge_feeds = PublicActivity::Activity.where(challenge_id: current_user.proposed_challenges).where(group_id: nil).order('created_at DESC').limit(10)

    personal_feeds = PublicActivity::Activity.where.not(id: one_to_one_challenge_feeds.ids).where.not(id: one_to_one_proposed_challenge_feeds.ids).where(owner_id: current_user.id).where(group_id: nil).order('created_at DESC').limit(10)

    friends_activity_feeds = UserFacebookAccount.new(current_user).friends_public_groups_activity_feeds(10)

    @activity_feeds = PublicActivity::Activity.where(id: groups_feeds + friends_activity_feeds + one_to_one_challenge_feeds + one_to_one_proposed_challenge_feeds + personal_feeds).order('created_at DESC').limit(10)
  end

  def apps
    redirect_to apps_path
  end

end
