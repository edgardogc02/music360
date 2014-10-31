class ModifyMaxNumberOfUsersInRedeemCodes < ActiveRecord::Migration
  def change
    rename_column :redeem_codes, :max_number_of_users, :max_number_of_uses
  end
end
