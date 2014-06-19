require 'spec_helper'

describe Level do

  context "Validations" do
    [:title, :xp].each do |attr|
      it "should validate presence of #{attr}" do
        should validate_presence_of(attr)
      end
    end
  end
end
