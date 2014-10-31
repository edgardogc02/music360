class AddGiftToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :gift, :boolean
  end
end
