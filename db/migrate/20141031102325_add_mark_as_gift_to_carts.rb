class AddMarkAsGiftToCarts < ActiveRecord::Migration
  def change
    add_column :carts, :mark_as_gift, :boolean
  end
end
