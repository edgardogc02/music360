require 'spec_helper'

describe UserPost do

  context "Associations" do
    it "sohuld belongs to user" do
      should belong_to(:user)
    end
  end

end
