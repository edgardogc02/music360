class RemoveColumnsFromPayments < ActiveRecord::Migration
  def change
    remove_column :payments, :txnid
    remove_column :payments, :item_name
    remove_column :payments, :receiver_email
    remove_column :payments, :payer_email
    remove_column :payments, :custom
    remove_column :payments, :itemid
    remove_column :payments, :createdtime
  end
end
