class AddImageToInstruments < ActiveRecord::Migration
  def change
    add_column :instruments, :image, :string
  end
end
