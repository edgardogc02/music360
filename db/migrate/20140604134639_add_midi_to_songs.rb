class AddMidiToSongs < ActiveRecord::Migration
  def change
    add_column :songs, :midi, :string
  end
end
