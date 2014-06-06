require 'spec_helper'

describe "PagesHome" do

  context "user signed in" do
    before(:each) do
      @user = login
    end

    it "should contain Quick start song section" do
      pending
    end

    it "should contain Quick start challenge section" do
      pending
    end

    it "should contain Top Songs section" do
      pending
    end

    it "should contain Top Artists section" do
      pending
    end

    it "should contain Top Users section" do
      pending
    end
  end

  context "user not signed in" do
    it "should not display home page" do
      visit root_path
      current_path.should eq(login_path)
    end
  end
end
