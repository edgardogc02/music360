require 'spec_helper'

describe "GroupActivities" do

  describe "user is signed in" do
    before(:each) do
      @song = create(:song, cost: 0)
      @user = login
    end

    it "should save activity when user post to the group" do
      pending
    end

    context "update group" do
      it "should save activity when description change" do
        pending
      end
      it "should not save activity when description doesn't change" do
        pending
      end
    end

  end
end