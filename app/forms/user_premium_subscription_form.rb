class UserPremiumSubscriptionForm

  include ActiveModel::Model

  attr_accessor :card_holdername, :card_number, :card_cvc, :card_expiry_date, :paymillToken


  validates :user_id, presence: true
  validates :premium_plan_id, presence: true
  validates :payment_method_id, presence: true

  # payment validations

#  validates :payment_method_id, presence: true
#  validates :amount, presence: true
#  validates :status, presence: true
#  validate :paymill_token_if_credit_card

  delegate :user_id, :premium_plan_id, :payment_method_id, to: :user_premium_subscription

#  delegate :amount, :status, :payment_method_id, :paymill_token, to: :payment

  def initialize(user_premium_subscription, payment)
    @user_premium_subscription = user_premium_subscription
    @payment = payment
  end

  def persisted?
    false
  end

  def user
    @user ||= User.new
  end

  def user_premium_subscription
    @user_premium_subscription ||= user.user_premium_subscriptions.build
  end

  def payment
    @payment ||= user.payments.build
  end

  def premium_plan
    @premium_plan ||= user_premium_subscription.premium_plan
  end

  def save(params)
    user_premium_subscription.attributes = params.slice(:premium_plan_id, :payment_method_id)
#    payment.attributes = params.slice(:amount, :payment_method_id, :paymill_token)

#    payment.status = "Confirmed"

    if valid?
      ActiveRecord::Base.transaction do
        generate_token
        user_premium_subscription.save
#        payment.save
#        Paymill::Payment.create(token: payment.paymill_token) if payment.paymill_token
      end
      true
    else
      false
    end
  end

  private

  def generate_token
    begin
      user_premium_subscription.token = SecureRandom.urlsafe_base64
    end while UserPremiumSubscription.exists?(token: user_premium_subscription.token)
  end

  def paymill_token_if_credit_card
    if self.payment_method_id == PaymentMethod::CREDIT_CARD_ID and self.paymill_token.blank?
      errors.add :payment_method_id, "Paymill token is missing"
    end
  end

end