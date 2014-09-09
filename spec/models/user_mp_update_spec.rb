require 'spec_helper'

describe UserMpUpdate do

  context "Validations" do
    [:user_id, :mp].each do |attr|
      it "should validates presence of #{attr}" do
        should validate_presence_of(attr)
      end
    end
  end

  context "Associations" do
    it "should belongs to user" do
      should belong_to(:user)
    end
  end

end
