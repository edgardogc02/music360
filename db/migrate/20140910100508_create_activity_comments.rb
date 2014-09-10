class CreateActivityComments < ActiveRecord::Migration
  def change
    create_table :activity_comments do |t|
      t.integer :commentable_id
      t.integer :commentable_type
      t.integer :user_id
      t.text :comment

      t.timestamps
    end
  end
end
