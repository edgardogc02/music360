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

  context "Scope" do
    it "should display visible instruments only" do
      guitar = create(:instrument, name: "guitar", visible: true)
      drums = create(:instrument, name: "drums", visible: true)
      saxo = create(:instrument, name: "saxo", visible: false)

      Instrument.visible.should eq([guitar, drums])
    end
  end

end
