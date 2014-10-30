class PaymentForm

  include ActiveModel::Model

  attr_accessor :card_holdername, :card_number, :card_cvc, :card_expiry_date

  # payment validations

  validates :payment_method_id, presence: true
  validates :amount, presence: true
  validate :paymill_token_if_credit_card

  delegate :user_id, :amount, :payment_method_id, :paymill_token, to: :payment

  def initialize(cart)
    @cart = cart
    @payment = cart.user.payments.build
  end

  def persisted?
    false
  end

  def user
    @user ||= cart.user
  end

  def payment
    @payment ||= user.payments.build
  end

  def cart
    @cart ||= cart
  end

  def save(params)
    payment.attributes = params.slice(:amount, :payment_method_id, :paymill_token, :currency)
    payment.status = "Confirmed"

    if valid?
      ActiveRecord::Base.transaction do
        payment.save
        save_user_purchased_songs
        save_user_purchased_subscriptions
        cart.assign_payment(payment)
        cart.destroy
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

  def save_user_purchased_songs
    cart.line_items.each do |line_item|
      if line_item.has_song?
        cart.user.user_purchased_songs.create(song: line_item.buyable, payment: payment)

        if paymill_token
          paymill_payment = Paymill::Payment.create(token: paymill_token)
          paymill_transaction = Paymill::Transaction.create(amount: (amount*100).to_i, currency: payment.currency, payment: paymill_payment.id, description: "#{user.email} songs checkout")
        end
      end
    end
  end

  def save_user_purchased_subscriptions
    cart.line_items.each do |line_item|
      if line_item.has_premium_plan?
        user_premium_subscription = cart.user.user_premium_subscriptions.build(premium_plan: line_item.buyable, payment: payment)

        if paymill_token
          paymill_client = Paymill::Client.create(email: user.email, description: user.email)
          paymill_payment = Paymill::Payment.create(token: paymill_token, client: paymill_client.id)
          paymill_subscription = Paymill::Subscription.create(offer: user_premium_subscription.premium_plan.paymill_id, client: paymill_client.id, payment: paymill_payment.id)
          user_premium_subscription.paymill_subscription_token = paymill_subscription.id
          user_premium_subscription.save
        end

        update_user_premium_account
      end
    end
  end

  def update_user_premium_account
    user.premium = true
    user.premium_until = premium_plan.duration_in_months.to_i.months.from_now
    user.save
  end

  def process_payment_with_paymill
  end

  def paymill_token_if_credit_card
    if self.payment_method_id == PaymentMethod::CREDIT_CARD_ID and self.paymill_token.blank?
      errors.add :payment_method_id, "Paymill token is missing"
    end
  end

  def purchase_notification
#    MandrillTemplateEmailNotifier.purchased_song_mandrill_template(user_purchased_song, payment).deliver
#    EmailNotifier.purchased_song_message(user_purchased_song, payment).deliver
  end

end