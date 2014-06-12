class AddDurationInMonthsToPremiumPlans < ActiveRecord::Migration
  def change
    add_column :premium_plans, :duration_in_months, :integer
  end
end
