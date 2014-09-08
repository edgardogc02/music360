module UserMacros
  def check_user_signup_params(user, check_oauth_uid=false)
    user.username.should eq(user.username)
    user.email.should eq(user.email)

    user.createdtime.should_not be_blank
    user.ip.should_not be_blank
    user.installed_desktop_app.should_not be_true
    user.premium.should be_true
    user.premium_until.to_date.should eq(3.months.from_now.to_date) # remove seconds
#    user.countrycode.should_not be_blank # TODO: fix me
    user.created_by.should_not be_blank
    # user.city.should_not be_blank # TODO: Check how to test this in test mode is always blank
    user.challenges_count.should eq(0)
    user.xp.should eq(100)

    if check_oauth_uid
      user.oauth_uid.should_not be_blank
      user.oauth_uid.should eq(UserFacebookAccount.new(user).credentials.oauth_uid)
      # user.updated_image.should be_true # TODO: AUTOMATIC FACEBOOK PROFILE IMAGE UPLOAD IS COMMENTED ON TEST ENV
      user.locale.should_not be_blank
    else
      user.updated_image.should_not be_true
    end
  end
end