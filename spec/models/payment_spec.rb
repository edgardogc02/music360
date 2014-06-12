require 'spec_helper'

describe Payment do

  context "Associations" do
    [:user, :payment_method].each do |assoc|
      it "should belongs to #{assoc}" do
        should belong_to(assoc)
      end
    end

    it "should have many user_premium_subscriptions" do
      should have_many(:user_premium_subscriptions)
    end
  end

end
