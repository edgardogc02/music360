class AddPaymentIdToUserPremiumSubscriptions < ActiveRecord::Migration
  def change
    add_column :user_premium_subscriptions, :payment_id, :integer
  end
end
