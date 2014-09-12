xml.instruct! :xml, :version => '1.0', :encoding => 'UTF-8'

xml.urlset "xmlns" => "http://www.sitemaps.org/schemas/sitemap/0.9" do

	xml.url do
		xml.loc root_url
		xml.priority 1.0
		xml.changefreq 'weekly'
	end

	Artist.all.each do |artist|
		xml.url do
			xml.loc artist_url(artist)
			xml.priority 1.0
	      	xml.changefreq 'daily'
		end
	end

	Song.all.each do |song|
		xml.url do
			xml.loc artist_song_url(song.artist, song)
			xml.priority 1.0
	      	xml.changefreq 'daily'
		end
	end

	xml.url do
		xml.loc apps_url
		xml.priority 1.0
		xml.changefreq 'weekly'
	end

	Challenge.all.each do |challenge|
		xml.url do
			xml.loc challenge_url(challenge)
			xml.priority 1.0
	      	xml.changefreq 'daily'
		end
	end

	xml.url do
		xml.loc music_teachers_url
		xml.priority 1.0
		xml.changefreq 'weekly'
	end

	xml.url do
		xml.loc music_artists_url
		xml.priority 1.0
		xml.changefreq 'weekly'
	end

	xml.url do
		xml.loc guitar_url
		xml.priority 1.0
		xml.changefreq 'weekly'
	end

	xml.url do
		xml.loc piano_url
		xml.priority 1.0
		xml.changefreq 'weekly'
	end

	xml.url do
		xml.loc drums_url
		xml.priority 1.0
		xml.changefreq 'weekly'
	end

	xml.url do
		xml.loc signup_url
		xml.priority 1.0
		xml.changefreq 'weekly'
	end

	xml.url do
		xml.loc login_url
		xml.priority 1.0
		xml.changefreq 'weekly'
	end

end
