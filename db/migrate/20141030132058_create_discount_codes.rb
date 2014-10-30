class CreateDiscountCodes < ActiveRecord::Migration
  def change
    create_table :discount_codes do |t|
      t.string :code
      t.datetime :valid_from
      t.datetime :valid_to

      t.timestamps
    end
  end
end
