require 'spec_helper'

describe SessionsController do

  describe "json authentication" do
    it "successfully json authentication" do
      user = create(:user, username: "testuser", password: "12345")
      user_access_token = user.auth_token

      post :create, { username: "testuser", password: "12345", format: :json }

      response.status.should eq(200)

      body = JSON.parse(response.body)
      body["request"].should eq(response.request.url)
      body["status"]["code"].should eq(200)
      body["status"]["message"].should eq("OK")
      body["response"]["user_access_token"].should eq(user_access_token)
    end

    it "failed json authentication" do
      user = create(:user, username: "testuser", password: "12345")
      user_access_token = user.auth_token

      post :create, { username: "testuser", password: "123456", format: :json }

      response.status.should eq(200)

      body = JSON.parse(response.body)
      body["request"].should eq(response.request.url)
      body["status"]["code"].should eq(401)
      body["status"]["message"].should eq("Unauthorized")
      body["response"]["user_access_token"].should eq("")
    end
  end

end