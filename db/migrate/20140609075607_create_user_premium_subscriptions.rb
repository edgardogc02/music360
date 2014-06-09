class CreateUserPremiumSubscriptions < ActiveRecord::Migration
  def change
    create_table :user_premium_subscriptions do |t|
      t.integer :user_id
      t.integer :premium_plan_id
      t.integer :payment_type_id
      t.string :token

      t.timestamps
    end
  end
end
