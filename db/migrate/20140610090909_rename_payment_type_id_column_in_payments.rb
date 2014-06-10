class RenamePaymentTypeIdColumnInPayments < ActiveRecord::Migration
  def change
    rename_column :payments, :payment_type_id, :payment_method_id
  end
end
