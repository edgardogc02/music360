module OmniauthMacros
  def mock_facebook_auth_hash
    OmniAuth.config.add_mock(:facebook, {:provider  => "facebook",
                                          :uid      => "100008301499042",
                                          :info     => { :email  => "facebook_kehfokn_user@tfbnw.net",
                                                         :name   => "Facebook test user",
                                                         :first_name  => "Facebook",
                                                         :last_name   => "test user"},
                                          :extra    => { :raw_info => { :locale => "en_US" }},
                                          :credentials => { :token      => "lk2j3lkjasldkjflk3ljsdf",
                                                            :expires_at => 10.days.from_now} })
  end

  def mock_facebook_friend_auth_hash
    OmniAuth.config.add_mock(:facebook, {:provider  => "facebook",
                                          :uid      => "1375536292736028",
                                          :info     => { :email  => "dick_cfrqtzm_smithberg@tfbnw.net",
                                                         :name   => "Dick Smithberg",
                                                         :first_name  => "Dick",
                                                         :last_name   => "Smithberg"},
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