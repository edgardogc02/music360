require 'spec_helper'

describe Payment do

  context "Associations" do
    [:user, :payment_method].each do |assoc|
      it "should belongs to #{assoc}" do
        should belong_to(assoc)
      end
    end

    [:user_premium_subscriptions, :user_purchased_songs].each do |rel|
      it "should have many #{rel}" do
        should have_many(rel)
      end
    end
  end

end
