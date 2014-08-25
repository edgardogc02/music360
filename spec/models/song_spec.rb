require 'spec_helper'

describe Song do

  context "Validations" do
    [:title, :writer, :length, :difficulty, :arranger_userid, :status, :published_at].each do |attr|
      it "should validate presence of #{attr}" do
        should validate_presence_of(attr)
      end
    end
  end

  context "Associations" do
    it "should belongs to artist" do
      should belong_to(:artist)
      should belong_to(:category)
    end

    it "should has many song ratings" do
       should have_many(:song_ratings).dependent(:destroy)
    end
  end

  context "Scopes" do
    it "should list all free songs" do
      free_song_1 = create(:song)
      free_song_2 = create(:song, cost: 0)
      paid_song = create(:song, cost: 1)

      Song.free.should eq([free_song_1, free_song_2])
    end

    it "should order songs by popularity" do
      most_popular_song = create(:song)
      popular_song = create(:song)
      unpopular_song = create(:song)
      unrated_song = create(:song)
      unrated_song_2 = create(:song)

      create(:song_rating, song: most_popular_song, rating: 5)
      create(:song_rating, song: most_popular_song, rating: 4)

      create(:song_rating, song: popular_song, rating: 5)
      create(:song_rating, song: popular_song, rating: 3)

      create(:song_rating, song: unpopular_song, rating: 1)

      Song.by_popularity.should eq([most_popular_song, popular_song, unpopular_song, unrated_song, unrated_song_2])
    end

    it "should list all free songs order by popularity" do
      most_popular_free_song = create(:song)
      popular_free_song = create(:song)
      unpopular_free_song = create(:song)
      unrated_free_song = create(:song)

      most_popular_paid_song = create(:song, cost: 1)
      popular_paid_song = create(:song, cost: 5.0)
      unpopular_paid_song = create(:song, cost: 4.5)
      unrated_paid_song = create(:song, cost: 7.0)

      create(:song_rating, song: most_popular_free_song, rating: 5)
      create(:song_rating, song: most_popular_free_song, rating: 4)

      create(:song_rating, song: popular_free_song, rating: 5)
      create(:song_rating, song: popular_free_song, rating: 3)

      create(:song_rating, song: unpopular_free_song, rating: 1)

      create(:song_rating, song: most_popular_paid_song, rating: 6)
      create(:song_rating, song: most_popular_paid_song, rating: 5)

      create(:song_rating, song: popular_paid_song, rating: 3)
      create(:song_rating, song: popular_paid_song, rating: 2)

      create(:song_rating, song: unpopular_paid_song, rating: 1)

      Song.free.by_popularity.should eq([most_popular_free_song, popular_free_song, unpopular_free_song, unrated_free_song])
    end

    it "should display only the not user created songs" do
      song = create(:song)
      user_created_song = create(:song, user_created: 1)

      Song.not_user_created.should eq([song])
    end

    it "should search by title" do
      song = create(:song, title: "song 1")
      song1 = create(:song, title: "lala")
      song2 = create(:song, title: "lala 1")
      song3 = create(:song, title: "second song")

      Song.by_title("son").should eq([song, song3])
    end

    it 'should list all the easy songs' do
      song1 = create(:song, difficulty: 1)
      song2 = create(:song, difficulty: 1)
      song3 = create(:song, difficulty: 1)
      song4 = create(:song, difficulty: 2)
      song5 = create(:song, difficulty: 3)

      Song.easy.should eq([song1, song2, song3])
    end

    it 'should list all the medium songs' do
      song1 = create(:song, difficulty: 1)
      song2 = create(:song, difficulty: 1)
      song3 = create(:song, difficulty: 2)
      song4 = create(:song, difficulty: 2)
      song5 = create(:song, difficulty: 3)

      Song.medium.should eq([song3, song4])
    end

    it 'should list all the hard songs' do
      song1 = create(:song, difficulty: 1)
      song2 = create(:song, difficulty: 1)
      song3 = create(:song, difficulty: 2)
      song4 = create(:song, difficulty: 3)
      song5 = create(:song, difficulty: 3)

      Song.hard.should eq([song4, song5])
    end

  end

  context "Methods" do
    it "should return a url for the desktop app" do
      song = create(:song)
      song.desktop_app_uri.should == "ic:song=#{URI::escape(song.title)}.mid"
    end
  end

end