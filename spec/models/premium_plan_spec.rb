require 'spec_helper'

describe PremiumPlan do

  context "Associations" do
    [:user_premium_subscriptions].each do |attr|
      it "should have many #{attr}" do
        should have_many(attr)
      end
    end
  end
end
