class ChangePaymillTokenInPayments < ActiveRecord::Migration
  def change
    change_column :payments, :paymill_token, :string
  end
end
