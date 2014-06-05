module LoginMacros
  def login
    login_form(create(:user))
  end

  def admin_login
    login_form(create(:admin))
  end

  def login_form(user)
    visit login_path
    within("#login-form") do
      fill_in 'username', with: user.username
      fill_in 'password', with: user.password
    end
    click_on 'sign_in'
    current_path.should eq(root_path)
    user
  end

end