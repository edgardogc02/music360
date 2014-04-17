require 'spec_helper'

describe UserFacebookFriend do

  context "Validations" do
    it "should validate attrs" do
      should validate_presence_of(:user_id)
      should validate_presence_of(:user_facebook_friend_id)
      should validate_uniqueness_of(:user_id).scoped_to(:user_facebook_friend_id)
    end
  end

  context "Associations" do
    it "should belongs to user" do
      should belong_to(:user)
    end

    it "should belongs to facebook friend using users table" do
      should belong_to(:facebook_friend).class_name('User').with_foreign_key('user_facebook_friend_id')
    end
  end

end
