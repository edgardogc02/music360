class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.string :txnid
      t.float :payment_amount
      t.string :payment_status
      t.string :item_name
      t.string :receiver_email
      t.string :payer_email
      t.string :custom
      t.string :itemid
      t.datetime :createdtime

      t.timestamps
    end
  end
end
