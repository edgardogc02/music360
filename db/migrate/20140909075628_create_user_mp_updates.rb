class CreateUserMpUpdates < ActiveRecord::Migration
  def change
    create_table :user_mp_updates do |t|
      t.integer :user_id
      t.integer :mp

      t.timestamps
    end
  end
end
