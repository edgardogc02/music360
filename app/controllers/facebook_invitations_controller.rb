class FacebookInvitationsController < ApplicationController

  skip_before_action :verify_authenticity_token

  def accept
  end

end