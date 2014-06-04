class RenameVisibleFromSongs < ActiveRecord::Migration
  def change
    rename_column :songs, :visible, :user_created
  end
end
