class PagesController < ApplicationController
  before_action :authorize, except: [:help]

  def home
    #users = User.not_deleted.exclude(current_user).search_user_relationships(current_user).limit(12) | User.not_deleted.exclude(current_user).limit(12)
    #@users = UserChallengeDecorator.decorate_collection(User.exclude(current_user.id).order_by_challenges_count.limit(12))

    users =  User.not_deleted.exclude(current_user).search_user_relationships(current_user).limit(4) | User.exclude(current_user.id).order_by_challenges_count.limit(4)

    @users = UserChallengeDecorator.decorate_collection(users.take(4))
    @songs = SongQuickStartDecorator.decorate_collection(Song.not_user_created.by_popularity.limit(4))

    @instruments = Instrument.visible

    @top_songs = SongDecorator.decorate_collection(Song.by_popularity.limit(4))
    @top_users = UserChallengeDecorator.decorate_collection(User.order_by_challenges_count.exclude(current_user).limit(4))
    @top_artist = Artist.all.limit(4)

    if UserFacebookAccount.new(current_user).connected?
      @top_fb_friends = UserChallengeDecorator.decorate_collection(User.order_by_challenges_count.limit(4))
    end

    @activity_feeds = UserPersonalActivityFeed.new(current_user).feeds.limit(6).page(1).per(10)

    @current_level = current_user.get_level
    @next_level = current_user.next_level

    if params[:rd]
      @redeem_code = RedeemCode.where(code: params[:rd]).first
    end
  end

  def apps
    redirect_to apps_path(params)
  end

end
