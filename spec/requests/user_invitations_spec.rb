require 'spec_helper'

describe "UserInvitations" do

  context "user signed in" do
    before(:each) do
      @song = create(:song, cost: 0)
      @user = login
    end

    it "should save the invitation in the db" do
      visit new_user_invitation_path
      fill_in "user_invitation_friend_email", with: 'lala@lala.com'
      click_on 'Invite'
      page.should have_content "An invitation to lala@lala.com was successfully sent. Invite more friends right away!"
      current_path.should eq(people_path)
      @user.user_invitations.pluck(:friend_email).should include('lala@lala.com')
    end

    it "should send an email to the invited user" do
      visit new_user_invitation_path
      fill_in "user_invitation_friend_email", with: 'invited_user@test.com'
      click_on 'Invite'
      last_email.to.should include("invited_user@test.com")
    end
  end

  context "user not signed in" do
    it "should not display the user invitations page" do
      visit new_user_invitation_path
      current_path.should eq(login_path)
    end
  end
end
