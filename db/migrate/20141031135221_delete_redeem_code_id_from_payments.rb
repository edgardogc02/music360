class DeleteRedeemCodeIdFromPayments < ActiveRecord::Migration
  def change
    remove_column :payments, :redeem_code_id
  end
end
