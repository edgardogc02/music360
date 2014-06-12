require 'spec_helper'

describe PremiumPlan do

  context "Associations" do
    [:user_premium_subscriptions].each do |attr|
      it "should have many #{attr}" do
        should have_many(attr)
      end
    end
  end

  context "Scopes" do
    it "should order the results by display position desc" do
      premium_plan_1 = create(:premium_plan, display_position: 2)
      premium_plan_2 = create(:premium_plan, display_position: 1)
      premium_plan_3 = create(:premium_plan, display_position: 4)
      premium_plan_4 = create(:premium_plan, display_position: 3)

      PremiumPlan.default_order.should eq([premium_plan_2, premium_plan_1, premium_plan_4, premium_plan_3])
    end
  end

end
