class DropPostComments < ActiveRecord::Migration
  def change
    drop_table :post_comments
  end
end
