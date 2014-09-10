require 'spec_helper'

describe ActivityComment do

  context "Validations" do
    [:user_id, :comment].each do |attr|
      it "should validate presence of #{attr}" do
        should validate_presence_of(attr)
      end
    end
  end

  context "Associations" do
    it "should belongs to user" do
      should belong_to(:user)
    end

    it "should belongs to activity" do
      should belong_to(:activity).class_name('PublicActivity::Activity')
    end
  end

end
