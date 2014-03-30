class CreateChallenges < ActiveRecord::Migration
  def change
    create_table :challenges, primary_key: "challenge_id" do |t|
      t.belongs_to :song, null: false
      t.boolean :public, default: false, null: false
      t.boolean :finished, default: false, null: false

      t.string   "user1",              null: false
      t.string   "user2"
      t.integer  "instrument",             null: false
      t.integer  "score_u1"
      t.integer  "score_u2"
      t.integer  "winner"

      t.timestamps
    end
  end
end
