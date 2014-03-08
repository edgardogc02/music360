class CreateChallenges < ActiveRecord::Migration
  def change
    create_table :challenges do |t|
      t.belongs_to :owner, null: false
      t.belongs_to :song, null: false
      t.boolean :public, default: false, null: false
      t.boolean :finished, default: false, null: false
      t.timestamps
    end
  end
end
