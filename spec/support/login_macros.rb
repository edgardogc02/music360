module LoginMacros
  def login
    login_form(create(:user))
  end

  def admin_login
    login_form(create(:admin))
  end

  def login_form(user)
    public_group_privacy = create(:public_group_privacy)
    level1 = create(:level, xp: 0)

    visit login_path
    within("#login-form") do
      fill_in 'username', with: user.username
      fill_in 'password', with: user.password
    end
    click_on 'sign_in'
    current_path.should eq(home_path)
    user
  end

end