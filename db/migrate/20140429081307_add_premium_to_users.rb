class AddPremiumToUsers < ActiveRecord::Migration
  def change
    add_column :users, :premium, :boolean
    add_column :users, :premium_until, :datetime
  end
end
