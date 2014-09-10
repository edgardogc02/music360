class CreateActivityLikes < ActiveRecord::Migration
  def change
    create_table :activity_likes do |t|
      t.integer :likeable_id
      t.string :likeable_type
      t.integer :user_id

      t.timestamps
    end
  end
end
