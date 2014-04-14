require 'spec_helper'

describe "Autologin" do

  describe "autologin a user" do
    before(:each) do
      @song = create(:song)
    end

    it "should autologin a user" do
      user = create(:user)
      visit people_path(autologin_user_auth_token: user.auth_token)

      current_path.should eq(people_path)
    end

    it "should not autologin a user with incorrect auth_token" do
      user = create(:user)
      visit people_path(autologin_user_auth_token: "incorrecttoken")

      current_path.should eq(login_path)
    end
  end

end
