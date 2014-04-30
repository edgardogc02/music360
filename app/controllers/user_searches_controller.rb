class UserSearchesController < ApplicationController  
  before_action :authorize

  def list_instrument_champ_users
    @users = User.not_deleted.page params[:page]    
    @title = "InstrumentChamp Friends"
    
    render 'show'
      
  end # end instrument_champ_users action
  
  def list_facebook_users    
    @users = current_user.groupies_to_connect_with.page params[:page]    
    @title = "Facebook friends on InstrumentChamp"

    render 'show'
      
  end # end instrument_champ_users action

  def modal_view_users

      if current_user.has_facebook_credentials?
        @fb_top_friends = current_user.facebook_top_friends(10)

        UserFacebookFriends.new(current_user, @fb_top_friends).save
        @fb_top_friends = current_user.groupies_to_connect_with
        
        @users_fb_count = @fb_top_friends.size
        @fb_top_friends = @fb_top_friends.limit(4)
      end

      @categories = UserCategory.all
      @users = User.not_deleted
      @users = @users.where(people_category_id: params[:type]) if params[:type].present?
      
      @users_count = @users.size
      @users = @users.limit(4)
      
      render 'modal', layout: false
    end

end # end SearchesController class
