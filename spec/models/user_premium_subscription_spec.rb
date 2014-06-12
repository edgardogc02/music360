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

  context "Scopes" do
    it "should return all user premium subscriptions about to expire in hr hours" do
      user_premium_subscription_1 = create(:user_premium_subscription)
      user_premium_subscription_2 = create(:user_premium_subscription)
      user_premium_subscription_3 = create(:user_premium_subscription)
      user_premium_subscription_4 = create(:user_premium_subscription)

      UserPremiumSubscription.about_to_expire_in_hours(2).should eq([])

      user_premium_subscription_1.user.premium_until = 2.hour.from_now
      user_premium_subscription_1.user.save

      UserPremiumSubscription.about_to_expire_in_hours(3).should eq([user_premium_subscription_1])
      UserPremiumSubscription.about_to_expire_in_hours(1).should eq([])

      user_premium_subscription_3.user.premium_until = 5.hour.from_now
      user_premium_subscription_3.user.save

      UserPremiumSubscription.about_to_expire_in_hours(3).should eq([user_premium_subscription_1])
      UserPremiumSubscription.about_to_expire_in_hours(1).should eq([])
      UserPremiumSubscription.about_to_expire_in_hours(12).should eq([user_premium_subscription_1, user_premium_subscription_3])
    end
  end

end
