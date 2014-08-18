require 'spec_helper'

describe Group do

  context "Validations" do
    [:name, :group_privacy_id].each do |attr|
      it "should validate presence of #{attr}" do
        should validate_presence_of(attr)
      end
    end
  end

  context "Associations" do
    it "should have many user_groups" do
      should have_many(:user_groups)
    end

    it "should have many challenges" do
      should have_many(:challenges)
    end

    it "should have many users through user_groups" do
      should have_many(:users).through(:user_groups)
    end

    it "should have many users through user_groups" do
      should have_many(:group_invitations).dependent(:destroy)
    end

    it "should have many posts with class name GroupPost" do
      should have_many(:posts).class_name("GroupPost").dependent(:destroy)
    end
  end

  context "Scopes" do
    it "should return all the public groups" do
      public_group_privacy = create(:public_group_privacy)
      group1 = create(:group, group_privacy: public_group_privacy)
      group2 = create(:group)
      group3 = create(:group, group_privacy: public_group_privacy)
      group4 = create(:group)

      Group.public.should eq([group1, group3])
    end

    it "should return all the closed groups" do
      closed_group_privacy = create(:closed_group_privacy)
      group1 = create(:group, group_privacy: closed_group_privacy)
      group2 = create(:group)
      group3 = create(:group, group_privacy: closed_group_privacy)
      group4 = create(:group)

      Group.closed.should eq([group1, group3])
    end

    it "should return all the closed groups" do
      secret_group_privacy = create(:secret_group_privacy)
      group1 = create(:group, group_privacy: secret_group_privacy)
      group2 = create(:group)
      group3 = create(:group, group_privacy: secret_group_privacy)
      group4 = create(:group)

      Group.secret.should eq([group1, group3])
    end

    it "should return the searcheable groups" do
      pgp = create(:public_group_privacy)
      cgp = create(:closed_group_privacy)
      sgp = create(:secret_group_privacy)

      pg1 = create(:group, group_privacy: pgp)
      pg2 = create(:group, group_privacy: pgp)
      cg1 = create(:group, group_privacy: cgp)
      cg2 = create(:group, group_privacy: cgp)
      sg1 = create(:group, group_privacy: sgp)
      sg2 = create(:group, group_privacy: sgp)

      Group.searchable.should eq([pg1, pg2, cg1, cg2])
    end

    it "should search by name" do
      g1 = create(:group, name: "Group 1")
      g2 = create(:group, name: "Secret group")
      g3 = create(:group, name: "Football Fans")

      Group.by_name("Gro").should eq([g1, g2])
      Group.by_name("fans").should eq([g3])
    end
  end

  context "Methods" do
    it "should return group leaders" do
      user = create(:user, xp: 10)
      user1 = create(:user, xp: 19)
      user2 = create(:user, xp: 7)
      user3 = create(:user, xp: 5)
      user4 = create(:user, xp: 0)

      group = create(:group)

      create(:user_group, group: group, user: user)
      create(:user_group, group: group, user: user1)
      create(:user_group, group: group, user: user2)
      create(:user_group, group: group, user: user3)
      create(:user_group, group: group, user: user4)

      group.leader_users(1).should eq([user1])
      group.leader_users(2).should eq([user1, user])
      group.leader_users.should eq([user1, user, user2, user3, user4])
    end

    context "user_can_see_posts?" do
      it "should let user see posts if group is public" do
        group = create(:group, group_privacy: create(:public_group_privacy))
        user = create(:user)
        create(:user_group, group: group, user: user)

        group.user_can_see_posts?(user).should be_true
      end

      it "should let user see posts if group is closed" do
        group = create(:group, group_privacy: create(:closed_group_privacy))
        user = create(:user)
        create(:user_group, group: group, user: user)

        group.user_can_see_posts?(user).should be_true
      end

      context "secret group" do
        before(:each) do
          @group = create(:group, group_privacy: create(:secret_group_privacy))
          @user = create(:user)
        end

        it "should let user see posts if is a member" do
          create(:user_group, group: @group, user: @user)
          @group.user_can_see_posts?(@user).should be_true
        end

        it "should not let user see posts if is not a member" do
          @group.user_can_see_posts?(@user).should_not be_true
        end
      end
    end

    context "user_can_post?" do
      before(:each) do
        @group = create(:group, group_privacy: create(:secret_group_privacy))
        @user = create(:user)
      end

      it "should let user post if is a group member" do
        create(:user_group, group: @group, user: @user)
        @group.user_can_post?(@user).should be_true
      end

      it "should not let user post if is not a group member" do
        @group.user_can_post?(@user).should_not be_true
      end
    end
  end

end
