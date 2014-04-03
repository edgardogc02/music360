class UserSentFacebookInvitationsController < ApplicationController

  skip_before_action :verify_authenticity_token, only: [:accept_invitation]

  def accept_invitation
    respond_to do |format|
      format.html
    end
  end

  def create
    if params[:user_sent_facebook_invitations][:facebook_user_ids]
      params[:user_sent_facebook_invitations][:facebook_user_ids].each do |facebook_user_id|
        current_user.user_sent_facebook_invitations.create(user_facebook_id: facebook_user_id)
      end
      flash[:notice] = t('user_invite_friends_invitations_sent_label')
    end
    respond_to do |format|
      format.js
    end
  end # end create action

end