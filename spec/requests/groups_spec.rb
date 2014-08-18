require 'spec_helper'

describe "Groups" do

  describe "user is signed in" do
    before(:each) do
      @song = create(:song, cost: 0)
      @user = login
      @group_privacy = create(:group_privacy)
    end

    it "should create a new group" do
      visit new_group_path

      fill_in "group_name", with: "Test group"
      choose "group_group_privacy_id_#{@group_privacy.id}"
      click_on "Create"

      Group.count.should eq(1)
      group = Group.first
      current_path.should eq(group_path(group))
      page.find('.alert-notice').should have_content('The group was successfully created')

      group.name.should eq("Test group")
      group.group_privacy.should eq(@group_privacy)
      group.initiator_user_id.should eq(@user.id)
    end

    it "user should belongs to the created group" do
      visit new_group_path

      fill_in "group_name", with: "Test group"
      choose "group_group_privacy_id_#{@group_privacy.id}"
      click_on "Create"

      Group.count.should eq(1)
      group = Group.first
      @user.groups.should eq([group])
    end

    context "error" do
      it "should not create a group without name" do
        visit new_group_path
        choose "group_group_privacy_id_#{@group_privacy.id}"
        click_on "Create"
        check_error_page
      end

      it "should not create a group without privacy" do
        visit new_group_path
        fill_in "group_name", with: "test group"
        click_on "Create"
        check_error_page
      end
    end

    def check_error_page
      Group.count.should eq(0)
      current_path.should eq(groups_path)
      page.find('.alert-warning').should have_content('Please enter a name and a privacy for the group')
    end

    context "show page" do
      it "should display the group show page with title and Founder" do
        group = create(:group)
        visit group_path(group)
        page.should have_content(group.name)
      end

      it "should display a members button" do
        group = create(:group)
        visit group_path(group)
        page.should have_link "Members", members_group_path(group)
      end

      context "buttons" do
        context "founder logged in" do
          before(:each) do
            @group = create(:group, initiator_user: @user)
            create(:user_group, user: @user, group: @group)
            visit group_path(@group)
          end

          it "should display a invite users button if founder logged in" do
            page.should have_link "Add members", group_group_invitations_path(@group)
          end
        end

        context "founder not logged in" do
          before(:each) do
            @group = create(:group)
            visit group_path(@group)
          end

          it "should not display a invite users button if founder not logged in" do
            page.should_not have_link "Add members", group_group_invitations_path(@group)
          end
        end

        context "user belongs to group" do
          it "should not display a join button if founder logged in" do
            group = create(:group, initiator_user: @user)
            create(:user_group, user: @user, group: group)
            visit group_path(group)
            page.should_not have_link "Join", join_group_path(group)
          end
        end

        context "user does not belongs to group" do
          it "should display a join button" do
            group = create(:group)
            visit group_path(group)
            page.should have_link "Join", join_group_path(group)
          end
        end
      end
    end

    context "members page" do
      before(:each) do
        @group = create(:group)
        @group_users = 3.times.inject([]) { |res, i| res << create(:user) }
        3.times.inject([]) { |res, i| create(:user_group, group: @group, user: @group_users[i]) }

        visit members_group_path(@group)
      end

      it "should list all the members of the group" do
        page.should have_content @group_users[0].username
        page.should have_content @group_users[1].username
        page.should have_content @group_users[2].username
      end

      it "should not list users that are not in the group" do
        user = create(:user)
        visit members_group_path(@group)
        page.should_not have_content user.username
      end
    end

    context "index" do
      it "should list my groups" do
        group = create(:group)
        create(:user_group, group: group, user: @user)
        user_group = create(:group, initiator_user: @user)
        create(:user_group, group: user_group, user: @user)
        user_group1 = create(:group, initiator_user: @user)
        create(:user_group, group: user_group1, user: @user)

        visit groups_path
        page.should have_content user_group.name
        page.should have_content user_group1.name
        page.should have_content group.name
      end

      it "should list the group invitations" do
        group = create(:group)
        create(:group_invitation, user: @user, group: group)

        visit groups_path
        page.should have_content "Invitations"
        page.should have_content group.name
        page.should have_link "Join", join_group_path(group)
      end

      it "should have a link to create a new group" do
        visit groups_path
        page.should have_link "Create new group", new_group_path
      end
    end

    context "edit" do
      it "should be able to edit the group name and privacy" do
        user_group = create(:group, initiator_user: @user)
        create(:user_group, group: user_group, user: @user)

        visit edit_group_path(user_group)
        fill_in "group_name", with: "new group name"
        click_on "Save"

        current_path.should eq(group_path(user_group))
        page.should have_content "new group name"
        page.find('.alert-notice').should have_content("The group was successfully updated")
      end
    end

    context "join" do
      context "public group" do
        before(:each) do
          gp = create(:public_group_privacy)
          @group = create(:group, group_privacy: gp)
        end

        it "should be able to join a public group if not member" do
          visit group_path(@group)
          click_on "Join"
          @user.groups.should eq([@group])
          page.find('.alert-notice').should have_content("You are now a member of #{@group.name}")
          current_path.should eq(group_path(@group))
        end

        it "should not be able to join a public group if already member" do
          create(:user_group, user: @user, group: @group)
          visit join_group_path(@group)
          page.find('.alert-warning').should have_content("You are already a member of #{@group.name}")
          current_path.should eq(group_path(@group))
        end
      end

      context "closed group" do
        before(:each) do
          gp = create(:closed_group_privacy)
          @group = create(:group, group_privacy: gp)
        end

        it "should be able to join a closed group" do
          visit group_path(@group)
          click_on "Join"
          @user.groups.should eq([@group])
          page.find('.alert-notice').should have_content("You are now a member of #{@group.name}")
          current_path.should eq(group_path(@group))
        end

        it "should not be able to join a closed group if already member" do
          create(:user_group, user: @user, group: @group)
          visit join_group_path(@group)
          page.find('.alert-warning').should have_content("You are already a member of #{@group.name}")
          current_path.should eq(group_path(@group))
        end
      end

      context "secret group" do
        before(:each) do
          gp = create(:secret_group_privacy)
          @group = create(:group, group_privacy: gp)
        end

        it "should be able to join a secret group if invited" do
          create(:group_invitation, group: @group, user: @user)
          visit group_path(@group)
          click_on "Join"
          @user.groups.should eq([@group])
          page.find('.alert-notice').should have_content("You are now a member of #{@group.name}")
          current_path.should eq(group_path(@group))
        end

        it "should not be able to join a secret group if invited and already member" do
          create(:group_invitation, group: @group, user: @user)
          create(:user_group, user: @user, group: @group)
          visit join_group_path(@group)
          page.find('.alert-warning').should have_content("You are already a member of #{@group.name}")
          current_path.should eq(group_path(@group))
        end

        it "should not be able to join a secret group if not invited" do
          visit group_path(@group)
          click_on "Join"
          @user.groups.should eq([])
          current_path.should eq(groups_path)
          page.find('.alert-warning').should have_content("You can't join #{@group.name} because it's a secret group and you have no invitation.")
        end
      end
    end

    it "should send an email to the invited user" do
      group = create(:group, initiator_user: @user)
      create(:user_group, user: @user, group: group)
      invited_user = create(:user)

      visit group_path(group)
      click_on "Add members"
      click_on "submit_group_invitation_#{invited_user.id}"

      last_email.to.should include(invited_user.email)
    end

    context "description textarea" do
      it "should not display the description textarea on the new form" do
        visit new_group_path
        page.should_not have_field "group_description"
      end

      it "should be able to update the description textarea on the edit form" do
        group = create(:group, initiator_user: @user)
        create(:user_group, user: @user, group: group)

        visit edit_group_path(group)
        new_description = "new group description"
        fill_in "group_description", with: "new group description"
        click_on "Save"

        group.reload
        group.description.should eq(new_description)
      end
    end

    context "group posts on group show page" do

      context "public and closed groups" do
        it "should list last 5 posts from a public group" do
          group = create(:group, initiator_user: @user, group_privacy: create(:public_group_privacy))
          check_posts(group)
        end

        it "should list last 5 posts from a closed group" do
          group = create(:group, initiator_user: @user, group_privacy: create(:closed_group_privacy))
          check_posts(group)
        end
      end

      context "secret group" do
        it "should list last 5 posts if the user is a member of the group" do
          group = create(:group, initiator_user: @user, group_privacy: create(:secret_group_privacy))
          check_posts(group)
        end

        it "should not list last 5 posts if the user is not a member of the group" do
          group = create(:group, group_privacy: create(:secret_group_privacy))
          user = create(:user)
          create(:user_group, user: user, group: group)

          post = create(:group_post, group: group, publisher: user)

          visit group_path(group)
          page.should_not have_content post.message
        end
      end

      def check_posts(group)
        create(:user_group, group: group, user: @user)
        posts = 6.times.inject([]) { |res, i| res << create(:group_post, group: group, publisher: @user) }

        visit group_path(group)

        (1..5).each do |i|
          page.should have_content posts[i].message
        end
        page.should_not have_content posts[0].message
      end

      context "user can post?" do
        it "should let user post if is a group member" do
          group = create(:group)
          create(:user_group, group: group, user: @user)

          visit group_path(group)
          page.should have_selector(:link_or_button, "Post")
        end

        it "should not let user post if is not a group member" do
          group = create(:group)
          visit group_path(group)
          page.should_not have_selector(:link_or_button, "Post")
        end
      end

      context "create challenge button" do
        it "should be able to see the button if user is member of the group" do
          group = create(:group, initiator_user: @user)
          create(:user_group, group: group, user: @user)
          visit group_path(group)
          page.should have_link "Create challenge", new_group_challenge_path(group)
        end

        it "should not be able to see the button if user is no member" do
          group = create(:group, initiator_user: @user)
          visit group_path(group)
          page.should_not have_link "Create challenge", new_group_challenge_path(group)
        end
      end

    end
  end

  describe "user is not signed in" do
    it "should not display new group page" do
      visit new_group_path
      current_path.should eq(login_path)
    end
  end

end