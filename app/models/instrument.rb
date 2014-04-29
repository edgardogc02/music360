class Instrument < ActiveRecord::Base

  mount_uploader :image, InstrumentImageUploader

  validates :name, presence: true

  has_many :users

end
