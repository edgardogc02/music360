class PagesController < ApplicationController
  before_action :authorize, except: [:help]

  def home
    #users = User.not_deleted.exclude(current_user).search_user_relationships(current_user).limit(12) | User.not_deleted.exclude(current_user).limit(12)
    #@users = UserChallengeDecorator.decorate_collection(User.exclude(current_user.id).order_by_challenges_count.limit(12))
        
    users = User.exclude(current_user.id).order_by_challenges_count.limit(6) | User.not_deleted.exclude(current_user).search_user_relationships(current_user).limit(12) | User.not_deleted.exclude(current_user).limit(12) 
        
    @users = UserChallengeDecorator.decorate_collection(users.take(12))
    @songs = SongQuickStartDecorator.decorate_collection(Song.not_user_created.free.by_popularity.limit(12))

    @instruments = Instrument.visible

    @top_songs = SongDecorator.decorate_collection(Song.by_popularity.limit(4))
    @top_users = UserChallengeDecorator.decorate_collection(User.order_by_challenges_count.exclude(current_user).limit(4))
    @top_artist = Artist.all.limit(4)
    
    if UserFacebookAccount.new(current_user).connected?
      @top_fb_friends = UserChallengeDecorator.decorate_collection(User.order_by_challenges_count.limit(4))
    end

  end

end
