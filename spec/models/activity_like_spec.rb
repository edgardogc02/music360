require 'spec_helper'

describe ActivityLike do

  context "Associations" do
    it "should belongs to user" do
      should belong_to(:user)
    end

    it "should belongs to activity" do
      should belong_to(:activity).class_name('PublicActivity::Activity')
    end
  end

  context "Validations" do
    it 'should validate user_should_like_same_activity_just_once' do
      pending
    end
  end

  context 'Methods' do
    it "should get by_user_and_activity" do
      pending
    end
  end

end
