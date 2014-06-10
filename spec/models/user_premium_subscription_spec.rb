require 'spec_helper'

describe UserPremiumSubscription do
  context "Validations" do
    [:user_id, :premium_plan_id, :payment_method_id].each do |attr|
      it "should have validate presence of #{attr}" do
        should validate_presence_of(attr)
      end
    end
  end

  context "Associations" do
    [:user, :premium_plan, :payment_method].each do |relation|
      it "should blelongs_to #{relation}" do
        should belong_to(relation)
      end
    end
  end

end
