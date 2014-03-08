class Song < ActiveRecord::Base
	belongs_to :artist
	belongs_to :category

	def cover_url
		cover || "http://placehold.it/300x300"
	end
end
