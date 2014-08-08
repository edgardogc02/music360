require 'spec_helper'

describe GroupInvitation do

  context "Associations" do
    [:group, :user].each do |assoc|
      it "should belongs to #{assoc}" do
        should belong_to(assoc)
      end
    end
  end

end
