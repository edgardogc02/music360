require 'spec_helper'

describe "UserPurchasedSongForm" do

  context "validations" do
    [:user_id, :song_id].each do |attr|
      it "should have validate presence of #{attr}" do
        pending "check why is not working"
        should validate_presence_of(attr)
      end
    end
  end

  context "non credit card payment" do
    it "should save a user_purchased_song and payment record" do
      non_credit_card_song_purchase
    end

    it "should not be able to buy the same song more than once" do
      non_credit_card_song_purchase
      params = {user_purchased_song_form: {amount: @song.cost, payment_method_id: @payment_method.id, song_id: @song.id, currency: @song.currency}}
      expect { expect { @form.save(params[:user_purchased_song_form]) }.to change{UserPurchasedSong.count}.by(0) }.to change{Payment.count}.by(0)
    end

    def non_credit_card_song_purchase
      @user = create(:user)
      @song = create(:paid_song, cost: 14.99)
      @payment_method = create(:payment_method)
      @form = UserPurchasedSongForm.new(@user.user_purchased_songs.build(song: @song))

      params = {user_purchased_song_form: {amount: @song.cost, payment_method_id: @payment_method.id, song_id: @song.id, currency: @song.currency}}
      expect { expect { @form.save(params[:user_purchased_song_form]) }.to change{UserPurchasedSong.count}.by(1) }.to change{Payment.count}.by(1)
    end
  end

  it "should send an email after the purchase" do
    user = create(:user)
    song = create(:paid_song, cost: 14.99)
    payment_method = create(:payment_method)
    form = UserPurchasedSongForm.new(user.user_purchased_songs.build(song: song))

    params = {user_purchased_song_form: {amount: song.cost, payment_method_id: payment_method.id, song_id: song.id, currency: song.currency}}
    form.save(params[:user_purchased_song_form])
    last_email.to.should include(user.email)
  end

  # for credit card payments a paymill token must be generated (using js). So this is tested in user_purchased_songs_spec

end
