require 'spec_helper'

describe "UserPremiumSusbcriptionManager" do

  before(:each) do
    @user = create(:premium_user)
    premium_plan = create(:premium_plan, duration_in_months: 3)
    user_premium_subscription = create(:user_premium_subscription, user: @user, premium_plan: premium_plan)
    @user_premium_subscription_manager = UserPremiumSubscriptionManager.new(user_premium_subscription)
  end

  context "renewal" do
    before(:each) do
      @user_premium_subscription_manager.renew
      @user.reload
    end

    it "should renew a user premium subscription" do
      @user.premium.should be_true
      @user.premium_until.to_date.should eq(@user_premium_subscription_manager.premium_plan.duration_in_months.to_i.months.from_now.to_date)
    end

    it "should send the user an email informing of the subscription renewal" do
      last_email.to.should include(@user.email)
      last_email.subject.should include("Premium subscription renewal")
    end
  end

  context "renewal alert" do
    it "should send the user an email alerting of the subscription renewal" do
      @user_premium_subscription_manager.renewal_alert
      last_email.to.should include(@user.email)
      last_email.subject.should include("Premium subscription renewal alert")
    end
  end

end
