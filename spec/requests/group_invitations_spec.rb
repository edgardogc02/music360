require 'spec_helper'

describe "GroupInvitations" do

  describe "user is signed in" do
    before(:each) do
      @song = create(:song, cost: 0)
      @user = login
      @group_privacy = create(:group_privacy)
    end

    context "user can invite users (is initiator)" do
      it "should list users to invite and the invite buttor for each user" do
        group = create(:group, initiator_user: @user)
        users = 3.times.inject([]) { |res, i| res << create(:user) }

        visit group_group_invitations_path(group)

        page.should have_content users[0].username
        page.should have_content users[1].username
        page.should have_content users[2].username

        page.should have_button("submit_group_invitation_#{users[0].id}")
        page.should have_button("submit_group_invitation_#{users[1].id}")
        page.should have_button("submit_group_invitation_#{users[2].id}")
      end
    end

    context "user can't invite users (is not initiator)" do
      it "should not display the invite button" do
        pending
      end
    end

    it "should not list for invitation those users that already members of the group" do
      group = create(:group, initiator_user: @user)
      create(:user_group, user: @user, group: group)

      users = 3.times.inject([]) { |res, i| res << create(:user) }

      visit group_group_invitations_path(group)

      page.should have_button("submit_group_invitation_#{users[0].id}")
      page.should have_button("submit_group_invitation_#{users[1].id}")
      page.should have_button("submit_group_invitation_#{users[2].id}")
      page.should_not have_button("submit_group_invitation_#{@user.id}")
    end

    it "should be able to invite a user to a group" do
      group = create(:group, initiator_user: @user)
      create(:user_group, user: @user, group: group)

      users = 3.times.inject([]) { |res, i| res << create(:user) }

      visit group_group_invitations_path(group)

      click_on "submit_group_invitation_#{users[0].id}"

      GroupInvitation.count.should eq(1)
      group_invitation = GroupInvitation.first

      group_invitation.group = group
      group_invitation.user = users[0]
      current_path.should eq(group_group_invitations_path(group))
      page.find('.alert-notice').should have_content("#{users[0].username} was successfully invited to join #{group.name}")
    end

  end

  describe "user is not signed in" do
    it "should not display group invitation page" do
      group = create(:group)
      visit group_group_invitations_path(group)
      current_path.should eq(login_path)
    end
  end

end