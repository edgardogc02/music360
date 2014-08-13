require 'spec_helper'

describe "GroupPosts" do

  describe "user is signed in" do
    before(:each) do
      @song = create(:song, cost: 0)
      @user = login
      @group_privacy = create(:public_group_privacy)
      @group = create(:group, initiator_user: @user, group_privacy: @group_privacy)
      @user_group = create(:user_group, group: @group, user: @user)
    end

    it "should be able to post some text from a group show page" do
      visit group_path(@group)

      post_text = "Some random text"

      fill_in "group_post[message]", with: post_text
      click_on "Post"

      current_path.should eq(group_path(@group))
      page.find('.alert-notice').should have_content('Your post was successfully created')

      GroupPost.count.should be(1)
      group_post = GroupPost.first

      group_post.publisher.should eq(@user)
      group_post.group.should eq(@group)
      group_post.message.should eq(post_text)
    end

    it "should not be able to post an empty message" do
      visit group_path(@group)

      click_on "Post"

      current_path.should eq(group_path(@group))
      page.find('.alert-warning').should have_content('Please write a message to post')

      GroupPost.count.should be(0)
    end
  end

  describe "user is not signed in" do
    it "should not be able to post something to a group" do
      group = create(:group)
      visit group_path(group)
      current_path.should eq(login_path)
    end
  end

end