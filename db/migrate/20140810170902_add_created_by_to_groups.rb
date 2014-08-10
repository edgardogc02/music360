class AddCreatedByToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :created_by, :string
  end
end
