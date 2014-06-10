require 'spec_helper'

describe "UserPaidSongForm" do

  context "validations" do
    [:user_id, :song_id].each do |attr|
      it "should have validate presence of #{attr}" do
        pending "check why is not working"
        should validate_presence_of(attr)
      end
    end
  end

  context "non credit card payment" do
    it "should save a user_paid_song and payment record" do
      non_credit_card_song_purchase
    end

    it "should not be able to buy the same song more than once" do
      non_credit_card_song_purchase
      params = {user_paid_song_form: {payment_amount: @song.cost, payment_type_id: @payment_type.id, song_id: @song.id}}
      expect { expect { @form.save(params[:user_paid_song_form]) }.to change{UserPaidSong.count}.by(0) }.to change{Payment.count}.by(0)
    end

    def non_credit_card_song_purchase
      @user = create(:user)
      @song = create(:paid_song, cost: 14.99)
      @payment_type = create(:payment_type)
      @form = UserPaidSongForm.new(@user.user_paid_songs.build(song: @song), @user.payments.build)

      params = {user_paid_song_form: {payment_amount: @song.cost, payment_type_id: @payment_type.id, song_id: @song.id}}
      expect { expect { @form.save(params[:user_paid_song_form]) }.to change{UserPaidSong.count}.by(1) }.to change{Payment.count}.by(1)
    end
  end

  # for credit card payments a paymill token must be generated (using js). So this is tested in user_paid_songs_spec

end
