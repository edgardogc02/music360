require 'spec_helper'

describe "UserPaidSongs" do

  context "user is signed in" do
    before(:each) do
      @song = create(:song, cost: 0)
      @user = login
      @paid_song = create(:paid_song, cost: 14.99)
    end

    it "should display song title and artist name on buy page" do
      visit buy_user_paid_song_path(@paid_song)
      page.should have_content(@paid_song.title)
      page.should have_content("from")
      page.should have_content(@paid_song.artist.title)
    end

    it "should display the song price in the buy page" do
      visit buy_user_paid_song_path(@paid_song)
      page.should have_content(@paid_song.cost)
    end
  end

  context "user is not signed in" do
    it "should not display new page" do
      paid_song = create(:paid_song)
      visit buy_user_paid_song_path(paid_song)
      current_path.should eq(login_path)
    end
  end

  it "should be able to pay with credit card", js: true do
    pending "poltergeist not working"
    paid_song = create(:paid_song, cost: 14.99)
    user = create(:user)
    visit login_path

    save_and_open_page
#    page.save_screenshot("page.jpg", :full => true)

#    find_button("sign_in_btn").trigger('click')

#    page.driver.debug

#    page.click_on 'Sign in'

#    within("#login-form") do
#      fill_in 'username', with: user.username
#      fill_in 'password', with: user.password
#    end

#    click_on 'sign_in'
#    current_path.should eq(root_path)
#    user

#    credit_card_payment_type = create(:payment_type, name: "Credit Card") #, id: PaymentType::CREDIT_CARD_ID)
#    user.admin = 1
#    user.save # TODO: REMOVE THIS AFTER BUY IS OPEN FOR ALL USERS

#    user.user_paid_songs.all.should be_empty
#    UserPaidSong.count.should eq(0)

#    visit songs_path
#    click_on "buy_song_#{paid_song.id}"

#      click_on "Credit Card"
#      fill_in 'user_paid_song_form_card_holdername', with: "John Doe"
#      fill_in 'user_paid_song_form_card_number', with: "4111111111111111"
#      fill_in 'user_paid_song_form_card_cvc', with: "111"
#    click_on "submit_buy_song_form"

#      UserPaidSong.count.should eq(1)
#      UserPaidSong.first.user_id.should eq(@user.id)
#      UserPaidSong.first.song_id.should eq(@paid_song.id)
  end

end