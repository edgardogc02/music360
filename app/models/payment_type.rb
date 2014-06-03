class PaymentType < ActiveRecord::Base

  validates :name, presence: true, uniqueness: true
  validates :display_position, presence: true
  validates :html_id, presence: true

  has_many :payments

  scope :default_order, -> { order(:display_position) }

  CREDIT_CARD_ID = 2

end
