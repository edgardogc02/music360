class ChangeCommentableTypeToActivityComments < ActiveRecord::Migration
  def change
    change_column :activity_comments, :commentable_type, :string
  end
end
