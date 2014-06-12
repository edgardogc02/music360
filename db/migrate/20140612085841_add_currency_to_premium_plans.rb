class AddCurrencyToPremiumPlans < ActiveRecord::Migration
  def change
    add_column :premium_plans, :currency, :string
  end
end
