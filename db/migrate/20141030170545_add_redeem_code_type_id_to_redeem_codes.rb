class AddRedeemCodeTypeIdToRedeemCodes < ActiveRecord::Migration
  def change
    add_column :redeem_codes, :redeem_code_type_id, :integer
  end
end
