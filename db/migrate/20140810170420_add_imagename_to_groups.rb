class AddImagenameToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :imagename, :string
  end
end
