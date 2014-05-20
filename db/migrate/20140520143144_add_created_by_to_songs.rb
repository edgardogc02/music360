class AddCreatedByToSongs < ActiveRecord::Migration
  def change
    add_column :songs, :created_by, :string
  end
end
