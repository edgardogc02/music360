class UserPaidSongForm

  include ActiveModel::Model

  attr_accessor :card_holdername, :card_number, :card_cvc, :card_expiry_date, :paymillToken

  # user_paid_song validations

  validates :user_id, presence: true
  validates :song_id, presence: true
  validate :user_and_song_must_be_unique

  # payment validations

  validate :payment_type_id, presence: true
  validate :payment_amount, presence: true
  validate :payment_status, presence: true
  validate :paymill_token_if_credit_card

  delegate :song_id, :user_id, to: :user_paid_song

  delegate :payment_amount, :payment_status, :payment_type_id, :paymill_token, to: :payment

  def initialize(user_paid_song, payment)
    @user_paid_song = user_paid_song
    @payment = payment
  end

  def persisted?
    false
  end

  def user
    @user ||= User.new
  end

  def user_paid_song
    @user_paid_song ||= user.user_paid_songs.build
  end

  def payment
    @payment ||= user.payments.build
  end

  def song
    @song ||= user_paid_song.song
  end

  def save(params)
    user_paid_song.song_id = params[:song_id]
    payment.payment_amount = params[:payment_amount]
    payment.payment_type_id = params[:payment_type_id]
    payment.paymill_token = params[:paymill_token] if params[:paymill_token]
    payment.payment_status = "Confirmed"

    if valid?
      generate_token
      if user_paid_song.save and payment.save
        Paymill::Payment.create(token: payment.paymill_token) if payment.paymill_token
      end
    else
      false
    end
  end

  private

  def generate_token
    begin
      user_paid_song.token = SecureRandom.urlsafe_base64
    end while UserPaidSong.exists?(token: user_paid_song.token)
  end

  def user_and_song_must_be_unique
    if UserPaidSong.where(user_id: user_id, song_id: song_id).first
      errors.add :song_id, "You already bought this song"
    end
  end

  def paymill_token_if_credit_card
    if self.payment_type_id == PaymentType::CREDIT_CARD_ID and self.paymill_token.blank?
      errors.add :payment_type_id, "Paymill token is missing"
    end
  end

end