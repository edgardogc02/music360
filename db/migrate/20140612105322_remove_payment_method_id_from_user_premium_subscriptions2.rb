class RemovePaymentMethodIdFromUserPremiumSubscriptions2 < ActiveRecord::Migration
  def change
    remove_column :user_premium_subscriptions, :payment_method_id
  end
end
