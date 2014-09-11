class UserPurchasedSongForm

  include ActiveModel::Model

  attr_accessor :card_holdername, :card_number, :card_cvc, :card_expiry_date

  # user_purchased_song validations

  validates :user_id, presence: true
  validates :song_id, presence: true
  validate :user_and_song_must_be_unique

  # payment validations

  validates :payment_method_id, presence: true
  validates :amount, presence: true
  validate :paymill_token_if_credit_card

  delegate :song_id, :user_id, to: :user_purchased_song

  delegate :amount, :payment_method_id, :paymill_token, to: :payment

  def initialize(user_purchased_song)
    @user_purchased_song = user_purchased_song
    @payment = @user_purchased_song.payment || @user_purchased_song.build_payment(user_id: user_purchased_song.user.id)
  end

  def persisted?
    false
  end

  def user
    @user ||= user_purchased_song.user
  end

  def user_purchased_song
    @user_purchased_song ||= user.user_purchased_songs.build
  end

  def payment
    @payment ||= user_purhcased_songs.payment
  end

  def song
    @song ||= user_purchased_song.song
  end

  def save(params)
    user_purchased_song.attributes = params.slice(:song_id)
    payment.attributes = params.slice(:amount, :payment_method_id, :paymill_token, :currency)
    payment.status = "Confirmed"

    if valid?
      ActiveRecord::Base.transaction do
        generate_token
        user_purchased_song.save
        if paymill_token
          paymill_payment = Paymill::Payment.create(token: paymill_token)
          paymill_transaction = Paymill::Transaction.create(amount: (amount*100).to_i, currency: payment.currency, payment: paymill_payment.id, description: "#{user.email} purchased #{song.title}")
        end
        purchase_notification
      end
      true
    else
      false
    end
  rescue Paymill::PaymillError => e
    errors.add :base, "There was a problem with your credit card. Please try again."
    false
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
    MandrillTemplateEmailNotifier.welcome_email_mandrill_template(user_purchased_song, payment).deliver
#    EmailNotifier.purchased_song_message(user_purchased_song, payment).deliver
  end

end