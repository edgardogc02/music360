namespace :users do

  task :user_auth_token => :environment do
    users = User.where("auth_token IS NULL")
    users.find_each(batch_size: 1000) do |user|
      begin
        user.auth_token = SecureRandom.urlsafe_base64
      end while User.exists?(:auth_token => user.auth_token)
      user.save
    end
  end

end