class UserPremiumSubscriptionsController < ApplicationController

  before_action :authorize

  def new
    @user_premium_subscription_form = UserPremiumSubscriptionForm.new(current_user.user_premium_subscriptions.build, current_user.payments.build)
    @user_premium_subscription_form.user_premium_subscription.premium_plan = PremiumPlan.find(params[:premium_plan_id]) if params[:premium_plan_id]
  end

  def show
    @user_premium_subscription = UserPremiumSubscription.find(params[:id])
    @paymill_payment_details = Paymill::Subscription.find(@user_premium_subscription.paymill_subscription_token).payment if @user_premium_subscription.paymill_subscription_token
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

  def destroy
    user_premium_subscription = UserPremiumSubscription.find(params[:id])
    user_premium_subscription_cancellation = UserPremiumSubscriptionCancellation.new(user_premium_subscription)

    if user_premium_subscription_cancellation.destroy
      redirect_to root_path, notice: "Your premium subscription was successfully deleted"
    else
      flash[:warning] = "Something went wrong. Please try again."
      redirect_to user_premium_subscription
    end
  end

  private

  def user_premium_subscription_params
    params.require(:user_premium_subscription_form).permit(:premium_plan_id, :payment_method_id, :amount, :paymill_token)
  end

end
