class AddPaymentIdToUserPurchasedSongs < ActiveRecord::Migration
  def change
    add_column :user_purchased_songs, :payment_id, :integer
  end
end
