module OmniauthMacros
  def mock_facebook_auth_hash
    OmniAuth.config.add_mock(:facebook, {:provider  => "facebook",
                                          :uid      => "123456789",
                                          :info     => { :email  => "test@test.com",
                                                         :name   => "Test User",
                                                         :first_name  => "Test",
                                                         :last_name   => "User"},
                                          :extra    => { :raw_info => { :locale => "en_US" }},
                                          :credentials => { :token      => "lk2j3lkjasldkjflk3ljsdf",
                                                            :expires_at => 10.days.from_now} })
  end

  def mock_facebook_friend_auth_hash
    OmniAuth.config.add_mock(:facebook, {:provider  => "facebook",
                                          :uid      => "1234567890",
                                          :info     => { :email  => "lars@willner.com",
                                                         :name   => "Lars Willner",
                                                         :first_name  => "Lars",
                                                         :last_name   => "Willner"},
                                          :extra    => { :raw_info => { :locale => "en_US" }},
                                          :credentials => { :token      => "lk2j3lkjasldkjflk3ljsdf",
                                                            :expires_at => 10.days.from_now} })
  end

  def new_mock_facebook_auth_hash
    OmniAuth.config.add_mock(:facebook, {:provider  => "facebook",
                                          :uid      => "12345678901",
                                          :info     => { :email  => "ladasd@lala.com",
                                                         :name   => "New Test User",
                                                         :first_name  => "New",
                                                         :last_name   => "Test User"},
                                          :extra    => { :raw_info => { :locale => "en_US" }},
                                          :credentials => { :token      => "lk2adsadasdasj3lkjasldkjflk3ljsdf",
                                                            :expires_at => 10.days.from_now} })
  end

  def mock_twitter_auth_hash
    OmniAuth.config.add_mock(:twitter, {:provider  => "twitter",
                                          :uid      => "123456",
                                          :info     => { :nickname  => "john_doe",
                                                         :name      => "John Doe"},
                                          :credentials => { :token => "a1b2c3d4weqwe812",
                                                            :secret => "abcdef1234"} })
  end
end