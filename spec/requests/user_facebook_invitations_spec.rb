require 'spec_helper'

describe "UserFacebookInvitations" do

  context "user signed in" do
    it "should save the invitation in the db" do
      pending
    end
  end

  context "user not signed in" do
    it "should not display the user invitations page" do
      visit new_user_invitation_path
      current_path.should eq(login_path)
    end
  end
end
