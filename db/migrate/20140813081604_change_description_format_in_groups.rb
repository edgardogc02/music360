class ChangeDescriptionFormatInGroups < ActiveRecord::Migration
  def up
    change_column :groups, :description, :text
  end

  def down
    change_column :groups, :description, :string
  end
end
