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
        page.should have_content("Founder")
        page.should have_link group.initiator_user.username, person_path(group.initiator_user)
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
            page.should have_link "Invite users", group_group_invitations_path(@group)
          end
        end

        context "founder not logged in" do
          before(:each) do
            @group = create(:group)
            visit group_path(@group)
          end

          it "should not display a invite users button if founder not logged in" do
            page.should_not have_link "Invite users", group_group_invitations_path(@group)
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
      it "should list 5 public groups" do
        pending
        public_privacy = create(:public_group_privacy)
        groups = 6.times.inject([]) { |res, i| res << create(:group, group_privacy: public_privacy) }

        visit groups_path
        page.should have_content "Public"
        page.should have_content groups[0].name
        page.should have_content groups[1].name
        page.should have_content groups[2].name
        page.should have_content groups[3].name
        page.should have_content groups[4].name
        page.should_not have_content groups[5].name
      end

      it "should list 5 closed groups" do
        pending
        closed_privacy = create(:closed_group_privacy)
        groups = 6.times.inject([]) { |res, i| create(:group, group_privacy: closed_privacy) }

        visit groups_path
        save_and_open_page
        page.should have_content "Closed"
        page.should have_content groups[0].name
        page.should have_content groups[1].name
        page.should have_content groups[2].name
        page.should have_content groups[3].name
        page.should have_content groups[4].name
        page.should_not have_content groups[5].name
      end

      it "should list the secret groups as well if the searcher user is a member" do
        pending
      end

      it "should have a link to create a new group" do
        pending
        visit groups_path
        page.should have_link "Create new group", new_group_path
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
          save_and_open_page
          @user.groups.should eq([])
          current_path.should eq(groups_path)
          page.find('.alert-warning').should have_content("You can't join #{@group.name} because it's a secret group and you have no invitation.")
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