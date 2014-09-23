class UserPremiumSubscriptionForm

  include ActiveModel::Model

  attr_accessor :card_holdername, :card_number, :card_cvc, :card_expiry_date

  validates :user_id, presence: true
  validates :premium_plan_id, presence: true
  validates :payment_method_id, presence: true
  validate :user_and_premium_plan_must_be_unique

  # payment validations

  validates :payment_method_id, presence: true
  validates :amount, presence: true
  validates :currency, presence: true
  validate :paymill_token_if_credit_card

  delegate :user_id, :premium_plan_id, :payment_id, to: :user_premium_subscription

  delegate :amount, :payment_method_id, :paymill_token, :currency, to: :payment

  def initialize(user_premium_subscription)
    @user_premium_subscription = user_premium_subscription
    @payment = @user_premium_subscription.payment || @user_premium_subscription.build_payment(user_id: user_premium_subscription.user.id)
  end

  def persisted?
    false
  end

  def user
    @user ||= user_premium_subscription.user
  end

  def user_premium_subscription
    @user_premium_subscription ||= user.user_premium_subscriptions.build
  end

  def payment
    @payment ||= user_premium_subscription.payment
  end

  def premium_plan
    @premium_plan ||= user_premium_subscription.premium_plan
  end

  def save(params)
    user_premium_subscription.attributes = params.slice(:premium_plan_id)
    payment.attributes = params.slice(:amount, :payment_method_id, :paymill_token, :currency)
    payment.status = "Confirmed"

    if valid?
      ActiveRecord::Base.transaction do
        generate_token
        user_premium_subscription.save
        process_payment_with_paymill
        subscription_notification
        update_user_premium_account
      end
      true
    else
      false
    end
  rescue Paymill::PaymillError => e
    errors.add :base, "There was a problem with your credit card. Please try again."
    false
  end

  def update_user_premium_account
    user.premium = true
    user.premium_until = premium_plan.duration_in_months.to_i.months.from_now
    user.save
  end

  private

  def process_payment_with_paymill
    if paymill_token
      paymill_client = Paymill::Client.create(email: user.email, description: user.email)
      paymill_payment = Paymill::Payment.create(token: paymill_token, client: paymill_client.id)
      paymill_subscription = Paymill::Subscription.create(offer: premium_plan.paymill_id, client: paymill_client.id, payment: paymill_payment.id)
      user_premium_subscription.paymill_subscription_token = paymill_subscription.id
      user_premium_subscription.save
    end
  end

  def user_and_premium_plan_must_be_unique
    if UserPremiumSubscription.where(user_id: user_id, premium_plan_id: premium_plan_id).first
      errors.add :premium_plan_id, "You already bought this premium plan"
    end
  end

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

  def subscription_notification
    MandrillTemplateEmailNotifier.user_premium_subscription_mandrill_template(user_premium_subscription).deliver
    # EmailNotifier.user_premium_subscription_message(user_premium_subscription).deliver
  end

end