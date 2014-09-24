class AddPremiumToSongs < ActiveRecord::Migration
  def change
    add_column :songs, :premium, :boolean
  end
end
