class AddTopToArtists < ActiveRecord::Migration
  def change
    add_column :artists, :top, :boolean
  end
end
