require 'spec_helper'

describe UserLevelUpgrade do

  context "Validations" do
    it "should validate username" do
      should validate_presence_of(:user_id)
      should validate_presence_of(:level_id)
    end
  end

  context "Associations" do
    [:user, :level].each do |assoc|
      it "should belongs to #{assoc}" do
        should belong_to(assoc)
      end
    end
  end

end
