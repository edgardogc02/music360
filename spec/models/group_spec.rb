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

    it "should have many users through user_groups" do
      should have_many(:users).through(:user_groups)
    end

    it "should have many group invitations" do
      should have_many(:group_invitations).dependent(:destroy)
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

end
