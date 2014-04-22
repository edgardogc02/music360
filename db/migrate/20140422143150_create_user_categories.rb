class CreateUserCategories < ActiveRecord::Migration
  def change
    create_table :user_categories do |t|
      t.string :title

      t.timestamps
    end
  end
end
