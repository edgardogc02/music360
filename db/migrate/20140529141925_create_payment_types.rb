class CreatePaymentTypes < ActiveRecord::Migration
  def change
    create_table :payment_types do |t|
      t.string :name
      t.integer :display_position

      t.timestamps
    end
  end
end
