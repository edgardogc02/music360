require 'spec_helper'

describe GroupPost do

  context "Validations" do
    it "should validate username" do
      [:publisher_id, :group_id, :message].each do |attr|
        should validate_presence_of(attr)
      end
    end
  end

  context "Associations" do
    it "should belongs to group" do
      should belong_to(:group)
    end

    it "should belongs to user" do
      should belong_to(:publisher).class_name('User').with_foreign_key("publisher_id")
    end
  end

end
