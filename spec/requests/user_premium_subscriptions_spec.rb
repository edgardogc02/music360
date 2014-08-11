require 'spec_helper'

describe "UserPremiumSubscriptions" do

  context "user is signed in" do
    before(:each) do
      @song = create(:song, cost: 0)
      @user = login
      @first_plan = create(:premium_plan)
      @second_plan = create(:premium_plan)
    end

    it "should display all plans details in the new page" do
      visit new_user_premium_subscription_path

      page.should have_content @first_plan.name
      page.should have_content @second_plan.name
      page.should have_content @first_plan.price
      page.should have_content @second_plan.price
      page.should have_link "Get Premium", href: new_user_premium_subscription_path(premium_plan_id: @first_plan.id)
      page.should have_link "Get Premium", href: new_user_premium_subscription_path(premium_plan_id: @second_plan.id)
    end

    it "should be able to see the subscription details" do
      create_subscription

      user_premium_subscription = @user.user_premium_subscriptions.first
      visit subscription_accounts_path

      page.should have_content "Your InstrumentChamp subscription will be automatically renewed the #{@user.premium_until}"
      page.should have_link "Cancel your subscription", href: "#" # user_premium_subscription_path(user_premium_subscription)
    end

    it "should be able to cancel a subscription" do
      create_subscription

      user_premium_subscription = @user.user_premium_subscriptions.first
      visit user_premium_subscription_path(user_premium_subscription)

      click_on "Cancel subscription"
      @user.reload
      @user.user_premium_subscriptions.should eq([])

      last_email.to.should include(@user.email)
      last_email.subject.should include("Premium subscription cancellation")
    end

    def create_subscription
      payment_method = create(:payment_method)
      @form = UserPremiumSubscriptionForm.new(@user.user_premium_subscriptions.build(premium_plan: @first_plan))

      params = {user_premium_subscription_form: {amount: @first_plan.price, payment_method_id: payment_method.id, premium_plan_id: @first_plan.id, currency: @first_plan.currency}}
      @form.save(params[:user_premium_subscription_form])
    end
  end

  context "user is not signed in" do
    it "should not display new page" do
      visit new_user_premium_subscription_path
      current_path.should eq(login_path)
    end
  end

end