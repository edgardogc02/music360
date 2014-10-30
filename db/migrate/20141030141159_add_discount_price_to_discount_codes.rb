class AddDiscountPriceToDiscountCodes < ActiveRecord::Migration
  def change
    add_column :discount_codes, :discount_price, :float
  end
end
