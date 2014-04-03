require 'spec_helper'

describe UserSentFacebookInvitation do

  context "Validations" do
    it "should validate presence of attributes" do
      should validate_presence_of(:user_id)
      should validate_presence_of(:user_facebook_id)
    end
  end

  context "Associations" do
    it { should belong_to(:user) }
  end

end
