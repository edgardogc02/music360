class DiscountCode < ActiveRecord::Base

  validates :code, presence: true

  has_many :carts

  def still_valid?
    valid_to >= Time.now
  end

end
