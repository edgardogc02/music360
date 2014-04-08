class AlterSongsTable < ActiveRecord::Migration

  def change
    add_column :songs, :writer, :string
    add_column :songs, :artist, :string
    add_column :songs, :arranger_userid, :integer
    add_column :songs, :published_at, :datetime
    add_column :songs, :publisher, :string
    add_column :songs, :cost, :float

    remove_column :songs, :arranger_id
  end

end
