class CreateChallengePosts < ActiveRecord::Migration
  def change
    create_table :challenge_posts do |t|
      t.integer :challenge_id
      t.integer :publisher_id
      t.text :message

      t.timestamps
    end
  end
end
