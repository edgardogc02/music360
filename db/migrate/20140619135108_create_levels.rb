class CreateLevels < ActiveRecord::Migration
  def change
    create_table :levels do |t|
      t.string :title
      t.integer :xp

      t.timestamps
    end
  end
end
