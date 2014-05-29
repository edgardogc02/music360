class PaymentType < ActiveRecord::Base

  validates :name, presence: true, uniqueness: true
  validates :display_position, presence: true

  scope :default_order, -> { order(:display_position) }

end
