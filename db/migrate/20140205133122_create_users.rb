class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :email
      t.string :avatar
      t.string :level
      t.string :password_digest

      t.belongs_to :people_category

      t.timestamps
    end
  end
end
