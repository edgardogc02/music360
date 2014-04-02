module OmniauthMacros
  def mock_facebook_auth_hash
    OmniAuth.config.add_mock(:facebook, {:provider  => "facebook",
                                          :uid      => "123456789",
                                          :info     => { :email  => "test@test.com",
                                                         :name   => "Test User",
                                                         :first_name  => "Test",
                                                         :last_name   => "User"},
                                          :credentials => { :token      => "lk2j3lkjasldkjflk3ljsdf",
                                                            :expires_at => 10.days.from_now} })
  end
end