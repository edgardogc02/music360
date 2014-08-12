class CreateGroupPosts < ActiveRecord::Migration
  def change
    create_table :group_posts do |t|
      t.integer :group_id
      t.integer :publisher_id
      t.text :message

      t.timestamps
    end
  end
end
