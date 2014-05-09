require 'spec_helper'

describe UserInvitation do
  context "Associations" do
    it "should belongs to user" do
      should belong_to(:user)
    end
  end
end
