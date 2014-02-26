class CreateArtists < ActiveRecord::Migration
  def change
    create_table :artists do |t|
      t.string :title

      t.timestamps
    end
  end
end
