class RemovePaymentMethodIdFromUserPremiumSubscriptions < ActiveRecord::Migration
  def change
    remove_column :payments, :payment_method_id
  end
end
