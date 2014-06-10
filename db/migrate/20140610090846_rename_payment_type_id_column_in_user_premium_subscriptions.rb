class RenamePaymentTypeIdColumnInUserPremiumSubscriptions < ActiveRecord::Migration
  def change
    rename_column :user_premium_subscriptions, :payment_type_id, :payment_method_id
  end
end
