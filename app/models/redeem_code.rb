class RedeemCode < ActiveRecord::Base

  belongs_to :redeemable, polymorphic: true

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

  private

  def generate_random_code
    ((Digest::SHA1.hexdigest("--#{Time.now.to_s}--"))[0..8]).upcase
  end

end
