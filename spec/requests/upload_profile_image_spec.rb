require 'spec_helper'
require 'carrierwave/test/matchers'


describe "UploadProfileImage" do

  before(:each) do
    @song = create(:song)
  end

  describe "user signed in" do
    before(:each) do
      @user = login

      UserImagenameUploader.enable_processing = true
      @uploader = UserImagenameUploader.new(@user, :imagename)
    end

    it "should be able to upload profile image using the url textfield" do
      visit profile_accounts_path
      page.should have_link "Change profile image", href: upload_profile_image_person_path(@user)
      click_on "Change profile image"
      current_path.should eq(upload_profile_image_person_path(@user))
      fill_in 'user_remote_imagename_url', with: "http://s3.amazonaws.com/37assets/svn/765-default-avatar.png"
      click_on "Save"
    end

    it "should be able to upload profile image using upload button" do
      pending "check how to do this"
    end
  end

  describe "user not signed in" do
    it "should not be able to upload a profile image" do
      user = create(:user)
      visit upload_profile_image_person_path(user)
      current_path.should eq(login_path)
    end
  end
end
