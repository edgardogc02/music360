class DeleteRedeemCodeTypeIdFromRedeemCodes < ActiveRecord::Migration
  def change
    remove_column :redeem_codes, :redeem_code_type_id
  end
end
