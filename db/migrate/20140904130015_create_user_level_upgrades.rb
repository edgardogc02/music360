class CreateUserLevelUpgrades < ActiveRecord::Migration
  def change
    create_table :user_level_upgrades do |t|
      t.integer :user_id
      t.integer :level_id

      t.timestamps
    end
  end
end
