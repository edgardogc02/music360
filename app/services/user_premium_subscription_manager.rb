class UserPremiumSubscriptionManager

  def initialize(user_premium_subscription)
    @user_premium_subscription = user_premium_subscription
  end

  def premium_plan
    @premium_plan ||= @user_premium_subscription.premium_plan
  end

  def user
    @user ||= @user_premium_subscription.user
  end

  def renew
    # just renew the user premium_until column. The payment will be automatically processed by paymill or paypayl.
    user.premium_until = premium_plan.duration_in_months.to_i.months.from_now
    user.save
    send_renew_notification_email
  end

  def destroy
    if @user_premium_subscription.paymill_subscription_token
      Paymill::Subscription.delete(@user_premium_subscription.paymill_subscription_token)
    end
    send_cancelation_notification_email
    @user_premium_subscription.destroy
  rescue Paymill::PaymillError => e
    false
  end

  private

  def send_cancelation_notification_email
    EmailNotifier.user_premium_subscription_cancellation_message(@user_premium_subscription).deliver
  end

  def send_renew_notification_email
    EmailNotifier.user_premium_subscription_renewal_message(@user_premium_subscription).deliver
  end

end