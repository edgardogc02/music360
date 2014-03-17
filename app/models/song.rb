class Song < ActiveRecord::Base
	belongs_to :artist
	belongs_to :category

	def cover_url
		cover || "http://placehold.it/300x300"
	end

	def song_uri
			# Format: "ic:song=Amazing%20grace.mid"
			"ic:song=#{URI::escape(title)}.mid"
	end
end
