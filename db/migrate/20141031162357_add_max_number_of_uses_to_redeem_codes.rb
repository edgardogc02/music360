class AddMaxNumberOfUsesToRedeemCodes < ActiveRecord::Migration
  def change
    add_column :redeem_codes, :max_number_of_users, :integer
  end
end
