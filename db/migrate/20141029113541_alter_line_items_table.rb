class AlterLineItemsTable < ActiveRecord::Migration
  def change
    remove_column :line_items, :quantity
    add_column :line_items, :buyable_id, :integer
    add_column :line_items, :buyable_type, :string
  end
end
