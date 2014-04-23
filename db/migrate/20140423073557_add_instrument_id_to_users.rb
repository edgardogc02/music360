class AddInstrumentIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :instrument_id, :integer
  end
end
