class CreateRedeemCodeTypes < ActiveRecord::Migration
  def change
    create_table :redeem_code_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
