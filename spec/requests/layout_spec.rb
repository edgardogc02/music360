require 'spec_helper'

describe "Layout" do

  before(:each) do
    @song = create(:song)
  end

  context "user signed in" do
    context "user is admin" do
      before(:each) do
        @user = admin_login
      end

      it "should contain link to admin" do
        visit home_path
        page.should have_link "Admin", href: admin_dashboard_path
      end
    end

    context "user is not admin" do
      before(:each) do
        @user = login
      end

      it "should not contain link to admin" do
        visit home_path
        page.should_not have_link "Admin", href: admin_dashboard_path
      end

      it "should not be able to see admin section" do
        visit admin_dashboard_path
        current_path.should eq(home_path)
      end
    end
  end

  context "user not signed in" do
    it "should not contain link to admin" do
      visit home_path
      page.should_not have_link "Admin", href: admin_dashboard_path
    end

    it "should not be able to see admin section" do
      visit admin_dashboard_path
      current_path.should eq(login_path)
    end
  end

end