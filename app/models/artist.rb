class Artist < ActiveRecord::Base
	extend FriendlyId

	mount_uploader :imagename, ArtistImageUploader

	paginates_per 30

	friendly_id :title, use: :slugged

	has_many :songs

  scope :top, -> { where(top: 1) }
  scope :not_top, -> { where('top = 0 OR top IS NULL') }
  scope :by_title, ->(title) { where('title LIKE ?', '%'+title+'%') }

	def bio_from_echonest
	  Echowrap.artist_biographies(name: self.title, results: 2, start: 1, license: "cc-by-sa").first if Echowrap.artist_biographies(name: self.title)
	end

  def self.top_from_echonest(limit)
    Echowrap.artist_top_hottt(results: limit, bucket: ['hotttnesss', 'images'])
  end

	def echonest_image
	  Echowrap.artist_images(name: self.title).first if Echowrap.artist_images(name: self.title)
  end

  def download_echonest_image
    echo_image = echonest_image
    if echo_image and self.imagename.blank?
      download_remote_image(echonest_image.url)
    end
  end

  def download_remote_image(image_url)
    self.remote_imagename_url = image_url
    save
  end

end
