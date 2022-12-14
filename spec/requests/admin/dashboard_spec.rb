require 'spec_helper'

describe "Dashboard" do

  before(:each) do
    @song = create(:song)
  end

  context "admin user signed in" do
    before(:each) do
      @user = admin_login
      @all_resources = ActiveAdmin.application.namespaces[:admin].resources
      visit admin_dashboard_path
    end

    it "should have users panel with total users" do
      page.should have_link User.count, admin_users_path
    end

    it "should have songs panel with total songs" do
      page.should have_link Song.count, admin_songs_path
    end

    it "should have payment types panel with total payment methods" do
      page.should have_link PaymentMethod.count, admin_payment_methods_path
    end

    it "should have levels panel with total levels" do
      page.should have_link Level.count, admin_levels_path
    end

    it "should have songs link in the header menu" do
      resource = @all_resources[Song]
      resource.should be_include_in_menu
    end

    it "should have users link in the header menu" do
      resource = @all_resources[User]
      resource.should be_include_in_menu
    end

    it "should have levels link in the header menu" do
      resource = @all_resources[Level]
      resource.should be_include_in_menu
    end

    it "should not have payment types link in the header menu" do
      resource = @all_resources[PaymentMethod]
      resource.should_not be_include_in_menu
    end
  end

end