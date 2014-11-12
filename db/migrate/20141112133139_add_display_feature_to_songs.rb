class AddDisplayFeatureToSongs < ActiveRecord::Migration
  def change
    add_column :songs, :display_feature, :boolean
  end
end
