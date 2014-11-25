class UserInvitationsController < ApplicationController
	before_action :authorize

	def new
	  @user_invitation = current_user.user_invitations.build

    if params[:tweet] and params[:tweet_text]
      @user_twitter_account = UserTwitterAccount.new(current_user)
      @tweet = @user_twitter_account.tweet("#{params[:tweet_text][0..104]} #{root_url}")
    end

    if params[:follow_artist]
      @user_twitter_account.follow(params[:to_follow])
    end

    if params[:layout] == "modal"
      render "new", layout: false
    elsif params[:path]
      redirect_to params[:path]
    else
      redirect_to people_path
    end

  end

  def create
    @user_invitation = current_user.user_invitations.build(user_invitation_params)
    if @user_invitation.invite
      flash[:notice] = "An invitation to #{params[:user_invitation][:friend_email]} was successfully sent. Invite more friends right away!"
      redirect_to people_path
    else
      flash.now[:warning] = "Some data were incorrect. Please try again."
      redirect_to people_path
    end
  end

  private

  def user_invitation_params
    params.require(:user_invitation).permit(:friend_email, :path, :follow_artist)
  end
end
