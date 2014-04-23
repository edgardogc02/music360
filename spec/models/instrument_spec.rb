require 'spec_helper'

describe Instrument do

  context "Validations" do
    it "should validate name" do
      should validate_presence_of(:name)
    end
  end

  context "Associations" do
    it "should have many users" do
      should have_many(:users)
    end
  end

end
