class AddDiscountCodeIdToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :discount_code_id, :integer
  end
end
