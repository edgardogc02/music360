class AddCreatedByToInstruments < ActiveRecord::Migration
  def change
    add_column :instruments, :created_by, :string
  end
end
