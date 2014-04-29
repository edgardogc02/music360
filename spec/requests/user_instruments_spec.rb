require 'spec_helper'

describe "UserInstrument" do

  before(:each) do
    @song = create(:song)
  end

  describe "user signed in" do
    before(:each) do
      @user = login
    end

    it "should be able to select a new instrument" do
      pending "test with js"
      guitar = create(:instrument, name: "Guitar")
      piano = create(:instrument, name: "Piano")

      visit edit_user_instrument_path(@user)

      select "#{guitar.name}", from: "user_instrument_id"
      click_on "Save"

      @user.reload
      @user.instrument.should eq(guitar)
    end

    it "should have a select instrument button in the profile page" do
      visit person_path(@user)
      page.should have_link "Choose your instrument", href: edit_user_instrument_path(@user.id)
    end

    it "should have a select instrument button in other user profile page" do
      user = create(:user)
      visit person_path(user)
      page.should_not have_link "Choose your instrument", href: edit_user_instrument_path(user.id)
    end

    it "should have the choosen instrument on the profile page" do
      @user.instrument = create(:instrument)
      @user.save

      visit person_path(@user)
      page.should have_content("Instrument")
      page.should have_content(@user.instrument.name)
    end

    it "should see 'no instrument chosen' if no instrument was choosen" do
      visit person_path(@user)
      page.should have_content("Instrument")
      page.should have_content("No instrument chosen")
    end

    it "should redirect to next page if next param is given" do
      pending "test with js"
      visit edit_user_instrument_path(@user, next: "user_groupies")
      click_on "Save"
      current_path.should eq(user_groupies_path)
    end

    it "should redirect to user profile if no next param is given" do
      pending "test with js"
      visit edit_user_instrument_path(@user)
      click_on "Save"
      current_path.should eq(person_path(@user))
    end
  end

  describe "user not signed in" do
    it "should not be able to select a new instrument" do
      user = create(:user)
      visit edit_user_instrument_path(user.id)
      current_path.should eq(login_path)
    end
  end

end
