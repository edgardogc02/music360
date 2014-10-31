class CreateUserRedeemCodes < ActiveRecord::Migration
  def change
    create_table :user_redeem_codes do |t|
      t.integer :user_id
      t.integer :redeem_code_id

      t.timestamps
    end
  end
end
