require 'spec_helper'

describe Payment do

  context "Associations" do
    [:user, :payment_method].each do |assoc|
      it "should belongs to #{assoc}" do
        should belong_to(assoc)
      end
    end
  end

end
