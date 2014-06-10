class UserPurchasedSongForm

  include ActiveModel::Model

  attr_accessor :card_holdername, :card_number, :card_cvc, :card_expiry_date, :paymillToken

  # user_purchased_song validations

  validates :user_id, presence: true
  validates :song_id, presence: true
  validate :user_and_song_must_be_unique

  # payment validations

  validates :payment_method_id, presence: true
  validates :payment_amount, presence: true
  validates :payment_status, presence: true
  validate :paymill_token_if_credit_card

  delegate :song_id, :user_id, to: :user_purchased_song

  delegate :payment_amount, :payment_status, :payment_method_id, :paymill_token, to: :payment

  def initialize(user_purchased_song, payment)
    @user_purchased_song = user_purchased_song
    @payment = payment
  end

  def persisted?
    false
  end

  def user
    @user ||= User.new
  end

  def user_purchased_song
    @user_purchased_song ||= user.user_purchased_songs.build
  end

  def payment
    @payment ||= user.payments.build
  end

  def song
    @song ||= user_purchased_song.song
  end

  def save(params)
    user_purchased_song.attributes = params.slice(:song_id)
    payment.attributes = params.slice(:payment_amount, :payment_method_id, :paymill_token)
    payment.payment_status = "Confirmed"

    if valid?
      ActiveRecord::Base.transaction do
        generate_token
        user_purchased_song.save
        payment.save
        Paymill::Payment.create(token: payment.paymill_token) if payment.paymill_token
        purchase_notification
      end
      true
    else
      false
    end
  end

  private

  def generate_token
    begin
      user_purchased_song.token = SecureRandom.urlsafe_base64
    end while UserPurchasedSong.exists?(token: user_purchased_song.token)
  end

  def user_and_song_must_be_unique
    if UserPurchasedSong.where(user_id: user_id, song_id: song_id).first
      errors.add :song_id, "You already bought this song"
    end
  end

  def paymill_token_if_credit_card
    if self.payment_method_id == PaymentMethod::CREDIT_CARD_ID and self.paymill_token.blank?
      errors.add :payment_method_id, "Paymill token is missing"
    end
  end

  def purchase_notification
    EmailNotifier.purchased_song_message(user_purchased_song, payment).deliver
  end

end