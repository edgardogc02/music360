class AddPaymillIdToPremiumPlans < ActiveRecord::Migration
  def change
    add_column :premium_plans, :paymill_id, :string
  end
end
