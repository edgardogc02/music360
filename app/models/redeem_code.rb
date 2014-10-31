class RedeemCode < ActiveRecord::Base

  belongs_to :redeem_code_type

  has_many :payments

  attr_accessor :gift_receiver

  def create_code_from_payment
    self.code = generate_random_code
    self.valid_from = Time.now
    self.valid_to = 1.year.from_now
    self.redeem_code_type = RedeemCodeType.gift
    save
  end

  def generate_random_code
    ((Digest::SHA1.hexdigest("--#{Time.now.to_s}--"))[0..8]).upcase
  end

end
