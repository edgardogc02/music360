require 'spec_helper'

describe UserSentFacebookInvitationsController do

  describe "POST 'create'" do
    it "should create new user sent invitations records" do
      @post_params = {:user_sent_facebook_invitations => {:facebook_user_ids => ["12312123", "1232343242342"]}}
      @current_user = create(:user)
      controller.stub!(:current_user).and_return(@current_user)
      xhr :post, :create, @post_params
    end
  end

end
