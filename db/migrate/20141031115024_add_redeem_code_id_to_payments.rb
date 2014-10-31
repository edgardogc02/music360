class AddRedeemCodeIdToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :redeem_code_id, :integer
  end
end
