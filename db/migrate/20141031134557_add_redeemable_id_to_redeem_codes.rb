class AddRedeemableIdToRedeemCodes < ActiveRecord::Migration
  def change
    add_column :redeem_codes, :redeemable_id, :integer
    add_column :redeem_codes, :redeemable_type, :string
  end
end
