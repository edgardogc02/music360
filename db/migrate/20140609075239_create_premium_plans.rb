class CreatePremiumPlans < ActiveRecord::Migration
  def change
    create_table :premium_plans do |t|
      t.float :price
      t.integer :display_position

      t.timestamps
    end
  end
end
