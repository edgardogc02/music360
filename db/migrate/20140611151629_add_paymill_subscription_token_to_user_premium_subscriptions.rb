class AddPaymillSubscriptionTokenToUserPremiumSubscriptions < ActiveRecord::Migration
  def change
    add_column :user_premium_subscriptions, :paymill_subscription_token, :string
  end
end
