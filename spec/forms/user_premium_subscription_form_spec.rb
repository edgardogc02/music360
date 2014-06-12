require 'spec_helper'

describe "UserPremiumSubscriptionForm" do

  context "validations" do
    [:user_id, :premium_plan_id, :payment_method_id].each do |attr|
      it "should have validate presence of #{attr}" do
        pending "check why is not working"
        should validate_presence_of(attr)
      end
    end
  end

  context "non credit card payment" do
    it "should save a user_premium_subscription and payment record" do
      non_credit_card_premium_subscription_purchase
    end

    it "should not be able to buy the same subscription more than once" do
      non_credit_card_premium_subscription_purchase
      params = {user_premium_subscription_form: {amount: @premium_plan.price, payment_method_id: @payment_method.id, premium_plan_id: @premium_plan.id, currency: @premium_plan.currency}}
      expect { expect { @form.save(params[:user_premium_subscription_form]) }.to change{UserPremiumSubscription.count}.by(0) }.to change{Payment.count}.by(0)
    end

    def non_credit_card_premium_subscription_purchase
      @user = create(:user)
      @premium_plan = create(:premium_plan)
      @payment_method = create(:payment_method)
      @form = UserPremiumSubscriptionForm.new(@user.user_premium_subscriptions.build(premium_plan: @premium_plan), @user.payments.build)

      params = {user_premium_subscription_form: {amount: @premium_plan.price, payment_method_id: @payment_method.id, premium_plan_id: @premium_plan.id, currency: @premium_plan.currency}}
      expect { expect { @form.save(params[:user_premium_subscription_form]) }.to change{UserPremiumSubscription.count}.by(1) }.to change{Payment.count}.by(1)

      user = UserPremiumSubscription.last.user
      user.premium.should be_true
      user.premium_until.to_date.should eq(@premium_plan.duration_in_months.months.from_now.to_date)
    end
  end

  it "should send an email after the purchase" do
    user = create(:user)
    premium_plan = create(:premium_plan)
    payment_method = create(:payment_method)
    form = UserPremiumSubscriptionForm.new(user.user_premium_subscriptions.build(premium_plan: premium_plan), user.payments.build)

    params = {user_premium_subscription_form: {amount: premium_plan.price, payment_method_id: payment_method.id, premium_plan_id: premium_plan.id, currency: premium_plan.currency}}
    form.save(params[:user_premium_subscription_form])
    last_email.to.should include(user.email)
  end

  # for credit card payments a paymill token must be generated (using js). So this is tested in user_purchased_songs_spec

end
