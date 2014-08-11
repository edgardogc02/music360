require 'spec_helper'

describe "Searches" do

  context "user signed in" do
    before(:each) do
      @user = login
    end

    it "should display search box in the header section" do
      pending
    end

    it "should display facebook friends in the search results" do
      pending
    end

    it "should display instrument champ users in the search results" do
      pending
    end

    it "should display artists in the search results" do
      pending
    end

    it "should display songs in the search results" do
      pending
    end

    it "should display challenges in the search results" do
      pending
    end

    it "should display groups in the search results" do
      pending
    end
  end

  context "user not signed in" do
    it "should not let not signed in users search" do
      pending
    end
  end
end
