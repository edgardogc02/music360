module LoginMacros
  def login
    user = create(:user)
    visit login_path
    within("#login-form") do
      fill_in 'username', with: user.username
      fill_in 'password', with: user.password
    end
    click_on 'Sign in'
    current_path.should eq(root_path)
    user
  end
end