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
  end

  context "user is not signed in" do
    it "should not display new page" do
      visit new_user_premium_subscription_path
      current_path.should eq(login_path)
    end
  end

end