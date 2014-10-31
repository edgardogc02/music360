class AddDiscountPercentageToDiscountCodes < ActiveRecord::Migration
  def change
    add_column :discount_codes, :discount_percentage, :integer
  end
end
