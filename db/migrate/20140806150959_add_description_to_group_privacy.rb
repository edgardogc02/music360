class AddDescriptionToGroupPrivacy < ActiveRecord::Migration
  def change
    add_column :group_privacies, :description, :string
  end
end
