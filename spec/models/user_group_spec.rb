require 'spec_helper'

describe UserGroup do

  context "Validations" do
    [:user_id, :group_id].each do |attr|
      it "should have validate presence of #{attr}" do
        should validate_presence_of(attr)
      end
    end

    it "should validate user_id and group_id are unique" do
      should validate_uniqueness_of(:user_id).scoped_to(:group_id)
    end
  end

  context "Associations" do
    [:user, :group].each do |assoc|
      it "should belongs to #{assoc}" do
        should belong_to(assoc)
      end
    end
  end

end
