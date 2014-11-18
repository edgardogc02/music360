class Artist < ActiveRecord::Base
	extend FriendlyId

	mount_uploader :imagename, ArtistImageUploader

	paginates_per 30

	friendly_id :title, use: :slugged

	has_many :songs

  belongs_to :user

  scope :top, -> { where(top: 1) }
  scope :not_top, -> { where('top = 0 OR top IS NULL') }
  scope :by_title, ->(title) { where('title LIKE ?', '%'+title+'%') }

  def self.top_from_echonest(limit)
    Echowrap.artist_top_hottt(results: limit, bucket: ['hotttnesss', 'images'])
  end

  def echonest_image
    download_echonest_image
  end

  def download_echonest_image
    echo_image = EchonestArtist.new(title).image
    if echo_image and self.imagename.blank?
      download_remote_image(echo_image.url)
    end
    imagename
  end

  def download_remote_image(image_url)
    self.remote_imagename_url = image_url
    save
  end

end
