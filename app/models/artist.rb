class Artist < ActiveRecord::Base
	extend FriendlyId

	mount_uploader :imagename, ArtistImageUploader

	paginates_per 30

	friendly_id :title, use: :slugged

	has_many :songs

	def bio
	  Echowrap.artist_biographies(name: self.title, results: 2, start: 1, license: "cc-by-sa").first if Echowrap.artist_biographies(name: self.title)
	end

	def public_image_url
	  Echowrap.artist_images(name: self.title).first if Echowrap.artist_images(name: self.title)
  end

end
