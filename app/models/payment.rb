class Payment < ActiveRecord::Base

  belongs_to :user
  belongs_to :payment_method
  belongs_to :redeem_code

  has_many :user_premium_subscriptions
  has_many :user_purchased_songs
  has_many :line_items

  def assign_redeem_code(redeem_code)
    self.redeem_code = redeem_code
    save
  end

end
