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
    payment.gift = cart.mark_as_gift
    payment.discount_code_id = cart.discount_code_id

    if valid?
      ActiveRecord::Base.transaction do
        payment.save
        save_user_purchased_songs unless payment.gift?
        cart.assign_payment(payment)

        if paymill_token
          paymill_payment = Paymill::Payment.create(token: paymill_token)
          paymill_transaction = Paymill::Transaction.create(amount: (amount*100).to_i, currency: payment.currency, payment: paymill_payment.id, description: "#{user.email} songs checkout")
        end

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
      end
    end
  end

  def paymill_token_if_credit_card
    if self.payment_method_id == PaymentMethod::CREDIT_CARD_ID and self.paymill_token.blank?
      errors.add :payment_method_id, "Paymill token is missing"
    end
  end

  def purchase_notification
    MandrillTemplateEmailNotifier.instrumentchamp_checkout_receipt_template(user, payment).deliver
  end

end