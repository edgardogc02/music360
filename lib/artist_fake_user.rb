class ArtistFakeUser

  def initialize(artist)
    @artist = artist
  end

  def user
  end

  def username
    @username ||= I18n.transliterate(@artist.title)
  end

  def email
    @email ||= "#{@artist.id}_#{rand(10000)}@fakeuser.com"
  end

  def remote_image
    @artist.imagename_url
  end

  def user_already_exists?
    @artist.user.present?
  end

  def real_user_already_exists?
    User.where(email: email).count > 0
  end

  def create_fake_user
    unless user_already_exists?
      user = User.new
      user.username = User.generate_new_username_from_string(username)
      user.password = User.generate_random_password(5)
      user.password_confirmation = user.password
      user.email = email
      user.challenges_count = 0
      user.xp = 100
      user.save!
      user.remote_imagename_url = remote_image
      user.save

      @artist.user = user
      @artist.save!
    end
  end

end
