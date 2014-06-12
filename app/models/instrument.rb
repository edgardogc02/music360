class Instrument < ActiveRecord::Base

  mount_uploader :image, InstrumentImageUploader

  validates :name, presence: true

  has_many :users
  has_many :song_score

  scope :visible, -> { where(visible: true) }

end
