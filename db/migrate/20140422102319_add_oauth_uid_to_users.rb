class AddOauthUidToUsers < ActiveRecord::Migration
  def change
    add_column :users, :oauth_uid, :string
  end
end
