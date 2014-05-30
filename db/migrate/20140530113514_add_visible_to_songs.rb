class AddVisibleToSongs < ActiveRecord::Migration
  def change
    add_column :songs, :visible, :boolean
  end
end
