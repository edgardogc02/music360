class RedeemCode < ActiveRecord::Base

  belongs_to :redeemable, polymorphic: true

  attr_accessor :gift_receiver

  def create_code_from_payment(payment)
    self.code = generate_random_code
    self.valid_from = Time.now
    self.valid_to = 1.year.from_now

    if payment.gift?
      self.redeemable = payment
    elsif payment.has_premium_plan_as_gift?
      self.redeemable = payment.premium_plan_as_gift
    end

    save
  end

  private

  def generate_random_code
    ((Digest::SHA1.hexdigest("--#{Time.now.to_s}--"))[0..8]).upcase
  end

end
