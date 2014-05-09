class UserFacebookInvitationsController < ApplicationController

  skip_before_action :verify_authenticity_token

  def create
    if params[:user_facebook_invitations] and params[:user_facebook_invitations][:facebook_user_ids]
      params[:user_facebook_invitations][:facebook_user_ids].each do |facebook_user_id|
        current_user.user_facebook_invitations.create(facebook_user_id: facebook_user_id)
      end
    end
    render text: "OK"
  end

  def accept
  end

end