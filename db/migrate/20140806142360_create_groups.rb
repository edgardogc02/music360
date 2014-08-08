class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name
      t.integer :initiator_user_id
      t.integer :group_privacy_id

      t.timestamps
    end
  end
end
