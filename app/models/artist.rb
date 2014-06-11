class Artist < ActiveRecord::Base
	extend FriendlyId
	
	mount_uploader :imagename, ArtistImageUploader
	
	paginates_per 30

	friendly_id :title, use: :slugged

	has_many :songs
end
