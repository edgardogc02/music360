require 'spec_helper'

describe UserFollower do

  context "Validations" do
    it "should contain a user id and a follower id" do
      should validate_presence_of(:user_id)
      should validate_presence_of(:follower_id)
    end
  end

  context "Associations" do
    it "should have belongs to followed and follower" do
      belong_to(:follower).class_name('User').with_foreign_key('country_id')
      belong_to(:followed).class_name('User').with_foreign_key('user_id')
    end
  end

end
