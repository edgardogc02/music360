class AddNameToPremiumPlans < ActiveRecord::Migration
  def change
    add_column :premium_plans, :name, :string
  end
end
