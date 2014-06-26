class Artist < ActiveRecord::Base
	extend FriendlyId

	mount_uploader :imagename, ArtistImageUploader

	paginates_per 30

	friendly_id :title, use: :slugged

	has_many :songs

  scope :top, -> { where(top: 1) }

	def bio_from_echonest
	  Echowrap.artist_biographies(name: self.title, results: 2, start: 1, license: "cc-by-sa").first if Echowrap.artist_biographies(name: self.title)
	end

  def self.top_from_echonest(limit)
    Echowrap.artist_top_hottt(results: limit, bucket: ['hotttnesss', 'images'])
  end

	def public_image_url(download=true)
	  image_url = Echowrap.artist_images(name: self.title).first if Echowrap.artist_images(name: self.title)

    if download and image_url
      download_remote_image(image_url.url)
    end
	  image_url
  end

  def download_echonest_image
    echonest_image = public_image_url
    if echonest_image
      download_remote_image(echonest_image.url)
    end
  end

  def download_remote_image(image_url)
    self.remote_imagename_url = image_url
    save
  end

end
