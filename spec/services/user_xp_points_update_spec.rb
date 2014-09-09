require 'spec_helper'

describe "UserXpPointsUpdate" do

  context "save" do

    def perform_update
      @user = create(:user)
      @xp_points_before = @user.xp
      @new_points = 200
      UserXpPointsUpdate.new(@user, @new_points).save
    end

    it 'should update user xp points' do
      perform_update
      @user.xp.should eq(@xp_points_before + @new_points)
    end

    context 'new level upgrade' do
      before(:each) do
        @level1 = create(:level)
        @level2 = create(:level, xp: 150, number: 2)
        perform_update
      end

      it 'should save a new record on user_level_upgrades table' do
        @user.user_level_upgrades.count.should eq(1)
        @user.user_level_upgrades.last.level.should eq(@level2)
      end

      it 'should save an activity feed' do
        activity = PublicActivity::Activity.where(owner_id: @user.id).order('created_at DESC').last

        activity.trackable.should eq(@user.user_level_upgrades.last)
        activity.key.should eq('user_level_upgrade.create')
      end
    end

    context 'not new level upgrade' do
      before(:each) do
        @level1 = create(:level)
        @level2 = create(:level, xp: 250, number: 2)
        perform_update
      end

      it 'should not save a new record on user_level_upgrades table' do
        @user.user_level_upgrades.count.should eq(0)
      end

      it 'should not save an activity feed if career level is not upgraded' do
        activity = PublicActivity::Activity.where(owner_id: @user.id).last.key.should_not eq('user_level_upgrade.create')
      end
    end

    context 'user_mp_updates table' do
      before(:each) do
        perform_update
      end

      it 'should save a new record on the user_mp_updates table' do
        @user.user_mp_updates.count.should eq(1)
        @user.user_mp_updates.last.mp.should eq(@new_points)
      end

      it 'should save a new activity feed about xp point update' do
        activity = PublicActivity::Activity.where(owner_id: @user.id).order('created_at DESC').last

        activity.trackable.should eq(@user.user_mp_updates.last)
        activity.key.should eq('user_mp_update.create')
      end
    end
  end

end