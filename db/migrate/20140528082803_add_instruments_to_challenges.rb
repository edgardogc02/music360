class AddInstrumentsToChallenges < ActiveRecord::Migration
  def change
    add_column :challenges, :instrument_u1, :integer
    add_column :challenges, :instrument_u2, :integer
  end
end
