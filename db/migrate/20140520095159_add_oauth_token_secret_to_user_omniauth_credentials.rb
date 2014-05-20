class AddOauthTokenSecretToUserOmniauthCredentials < ActiveRecord::Migration
  def change
    add_column :user_omniauth_credentials, :oauth_token_secret, :string
  end
end
