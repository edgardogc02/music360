class UserPremiumSubscriptionCancellation

  def initialize(user_premium_subscription)
    @user_premium_subscription = user_premium_subscription
  end

  def destroy
    if @user_premium_subscription.paymill_subscription_token
      Paymill::Subscription.delete(@user_premium_subscription.paymill_subscription_token)
    end
    @user_premium_subscription.destroy
  rescue Paymill::PaymillError => e
    false
  end

end