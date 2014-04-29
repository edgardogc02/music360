module UserMacros
  def check_user_signup_params(user, check_oauth_uid=false)
    user.username.should eq(user.username)
    user.email.should eq(user.email)

    user.confirmed.should_not be_blank
    user.ip.should_not be_blank
    user.installed_desktop_app.should_not be_true
    user.premium.should be_true
    user.premium_until.to_date.should eq(3.months.from_now.to_date) # remove seconds

    if check_oauth_uid
      user.oauth_uid.should_not be_blank
      user.oauth_uid.should eq(user.facebook_credentials.oauth_uid)
      user.updated_image.should be_true
    else
      user.updated_image.should_not be_true
    end
  end
end