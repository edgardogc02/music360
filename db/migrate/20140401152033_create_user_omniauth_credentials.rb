class CreateUserOmniauthCredentials < ActiveRecord::Migration
  def change
    create_table :user_omniauth_credentials do |t|
      t.integer :user_id
      t.string :provider
      t.string :oauth_uid
      t.string :username
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :oauth_token
      t.datetime :oauth_expires_at

      t.timestamps
    end
  end
end
