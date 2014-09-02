require 'spec_helper'

describe PostComment do
  context "Validations" do
    [:user_id, :comment].each do |attr|
      it "should validate pressence of #{attr}" do
        should validate_presence_of(attr)
      end
    end
  end

  context "Associations" do
    it "should belongs to user" do
      should belong_to(:user)
    end

    it "should belongs to group" do
      should belong_to(:commentable)
    end
  end
end
