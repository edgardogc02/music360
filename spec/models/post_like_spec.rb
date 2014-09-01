require 'spec_helper'

describe PostLike do

  context "Associations" do
    it "should belongs to group" do
      should belong_to(:likeable)
    end

    it "should belongs to user" do
      should belong_to(:user)
    end
  end

end
