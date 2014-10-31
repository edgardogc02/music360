class CreatePremiumPlanAsGifts < ActiveRecord::Migration
  def change
    create_table :premium_plan_as_gifts do |t|
      t.float :price
      t.integer :display_position
      t.string :name
      t.integer :duration_in_months
      t.string :currency

      t.timestamps
    end
  end
end
