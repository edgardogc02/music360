class AddCopyrightToSongs < ActiveRecord::Migration
  def change
    add_column :songs, :copyright, :string
  end
end
