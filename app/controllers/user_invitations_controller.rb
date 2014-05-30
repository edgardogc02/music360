class UserInvitationsController < ApplicationController
	before_action :authorize

	def new
	  @user_invitation = current_user.user_invitations.build

    if params[:tweet] and params[:tweet_text]
      @user_twitter_account = UserTwitterAccount.new(current_user)
      @tweet = @user_twitter_account.tweet("#{params[:tweet_text][0..104]} #{root_url}")
    end
  end

  def create
    @user_invitation = current_user.user_invitations.build(user_invitation_params)
    if @user_invitation.invite
      flash[:notice] = "An invitation to #{params[:user_invitation][:friend_email]} was successfully sent. Invite more friends right away!"
      redirect_to new_user_invitation_path
    else
      flash.now[:warning] = "Some data were incorrect. Please try again."
      render "new"
    end
  end

  private

  def user_invitation_params
    params.require(:user_invitation).permit(:friend_email)
  end
end
