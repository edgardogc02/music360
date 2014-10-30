class AddDiscountCodeIdToCarts < ActiveRecord::Migration
  def change
    add_column :carts, :discount_code_id, :integer
  end
end
