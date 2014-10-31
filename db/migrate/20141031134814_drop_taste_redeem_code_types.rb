class DropTasteRedeemCodeTypes < ActiveRecord::Migration
  def change
    drop_table :redeem_code_types
  end
end
