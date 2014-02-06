class Challenge < ActiveRecord::Base
	belongs_to :user
	has_one :song
end
