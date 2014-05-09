class AddVisibleToInstruments < ActiveRecord::Migration
  def change
    add_column :instruments, :visible, :boolean
  end
end
