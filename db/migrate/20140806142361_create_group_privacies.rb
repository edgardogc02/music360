class CreateGroupPrivacies < ActiveRecord::Migration
  def change
    create_table :group_privacies do |t|
      t.string :name

      t.timestamps
    end
  end
end
