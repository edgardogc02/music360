class RedeemCode < ActiveRecord::Base

  belongs_to :redeemable, polymorphic: true

  validate :gift_receiver_is_valid

  attr_accessor :gift_receiver

  def create_code_from_payment(payment)
    self.code = generate_random_code
    self.valid_from = Time.now
    self.valid_to = 1.year.from_now
    self.max_number_of_uses = 1

    if payment.gift?
      self.redeemable = payment
    elsif payment.has_premium_plan_as_gift?
      self.redeemable = payment.premium_plan_as_gift
    end

    save
  end

  def still_valid?
    valid_to >= Time.now and valid_from <= Time.now
  end

  def still_usable?
    max_number_of_uses > UserRedeemCode.where(redeem_code: self).count
  end

  def send_emails(gift_giver)
    if Rails.env.production? and gift_receiver
      receiver_email = gift_receiver_is_email? ? gift_receiver : gift_receiver.email
      MandrillTemplateEmailNotifier.gift_from_friend_mandrill_template(receiver_email, gift_giver.username, self).deliver
      MandrillTemplateEmailNotifier.gift_accepted_mandrill_template(gift_giver, gift_receiver).deliver
    end
  end

  private

  def generate_random_code
    ((Digest::SHA1.hexdigest("--#{Time.now.to_s}--"))[0..8]).upcase
  end

  def gift_receiver_is_email?
    gift_receiver and gift_receiver.include?('@')
  end

  def gift_receiver_is_valid
    if gift_receiver
      if !gift_receiver_is_email? and User.find_by_username(gift_receiver).nil? and User.find_by_email(gift_receiver).nil?
        errors.add :gift_receiver, "That user doesn't exist on InstrumentChamp"
        false
      end
    end
  end

end
