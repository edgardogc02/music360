class RedeemCodeType < ActiveRecord::Base

  has_many :redeem_codes

  def self.gift
    RedeemCodeType.where(name: 'gift').first
  end

end
