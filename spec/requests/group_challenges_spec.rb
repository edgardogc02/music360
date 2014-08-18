require 'spec_helper'

describe "GroupChallenges" do

  describe "user is signed in" do
    before(:each) do
      @song = create(:song, cost: 0)
      @user = login
      @group_privacy = create(:group_privacy)
      @group = create(:group)
    end

    context "user is a member of the group" do
      it "should be able to create a new group challenge" do
        create(:user_group, group: @group, user: @user)
        visit group_path(@group)

        page.should have_link "Create challenge", new_group_challenge_path(@group)
        click_on "new_group_challenge"
        click_on "challenge_#{@song.id}"
        click_on "Start Challenge"

        challenge = Challenge.last
        current_path.should eq(group_challenge_path(@group, challenge))
        challenge.group = @group
      end
    end

    context "user is not a member of the group" do
      it "should not display link create challenge" do
        visit group_path(@group)
        page.should_not have_link "Create challenge", new_group_challenge_path(@group)
      end
    end

    context "show page" do
      it "should display the song name" do
        pending
      end
      context "user belongs to group" do
        it "should show the start challenge button" do
          pending
        end
      end
      context "user doesn't belong to group" do
        it "should not display the start challenge button" do
          pending
        end
      end

      it "should display the users that already played the challenge" do
        pending
      end
    end

  end

  describe "user is not signed in" do
    it "should not display the group page" do
      group = create(:group)
      visit group_path(group)
      current_path.should eq(login_path)
    end
  end

end