class AddUpdatedImageToUsers < ActiveRecord::Migration
  def change
    add_column :users, :updated_image, :boolean
  end
end
