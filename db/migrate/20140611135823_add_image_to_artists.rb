class AddImageToArtists < ActiveRecord::Migration
  def change
    add_column :artists, :imagename, :string
    add_column :artists, :created_by, :integer
  end
end
