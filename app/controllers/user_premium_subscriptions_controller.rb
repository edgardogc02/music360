class UserPremiumSubscriptionsController < ApplicationController

  before_action :authorize

  def new
    @user_premium_subscription_form = UserPremiumSubscriptionForm.new(current_user.user_premium_subscriptions.build, current_user.payments.build)
  end

  def show
    @user_premium_subscription = UserPremiumSubscription.find(params[:id])
  end

  def create
    @user_premium_subscription_form = UserPremiumSubscriptionForm.new(current_user.user_premium_subscriptions.build, current_user.payments.build)

    if @user_premium_subscription_form.save(user_premium_subscription_params)
      redirect_to @user_premium_subscription_form.user_premium_subscription, notice: "You have successfully updated your account to premium"
    else
      flash.now[:warning] = "Something went wrong. Please try again."
      render "new"
    end
  end

  private

  def user_premium_subscription_params
    params.require(:user_premium_subscription_form).permit(:premium_plan_id, :payment_type_id)
  end

end
