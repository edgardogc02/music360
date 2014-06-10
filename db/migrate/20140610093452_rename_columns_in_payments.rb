class RenameColumnsInPayments < ActiveRecord::Migration
  def change
    rename_column :payments, :payment_amount, :amount
    rename_column :payments, :payment_status, :status
  end
end
