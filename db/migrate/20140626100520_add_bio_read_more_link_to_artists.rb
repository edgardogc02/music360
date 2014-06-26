class AddBioReadMoreLinkToArtists < ActiveRecord::Migration
  def change
    add_column :artists, :bio_read_more_link, :string
  end
end
