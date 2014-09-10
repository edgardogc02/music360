class UpdateActivityComments < ActiveRecord::Migration
  def change
    add_column :activity_comments, :activity_id, :integer
    remove_column :activity_comments, :commentable_id, :integer
    remove_column :activity_comments, :commentable_type, :string
  end
end
