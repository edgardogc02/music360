require 'spec_helper'

describe "SongLists" do

  describe "user is signed in" do
    before(:each) do
      @song = create(:song, cost: 0)
      @user = login
    end

    context 'my songs' do
      it 'should list all the user uploaded songs' do
        pending
      end

      it 'should list all the user bought premium songs' do
        pending
      end

      it 'should list all the free songs' do
        pending
      end

      it 'should show the songs difficulty filters' do
        visit list_songs_path(view: "my_songs")
        check_filters
      end
    end

    context 'most popular' do
      it 'should list all the songs order y popularity' do
        pending
      end

      it 'should show the songs difficulty filters' do
        visit list_songs_path(view: "most_popular")
        check_filters
      end
    end

    context 'new' do
      it 'should list all the songs listed by published at date' do
        pending
      end

      it 'should show the songs difficulty filters' do
        visit list_songs_path(view: "new")
        check_filters
      end

      it 'should show the easy songs' do
        song1 = create(:song, difficulty: 1)
        song2 = create(:song, difficulty: 1)
        song3 = create(:song, difficulty: 2)
        song4 = create(:song, difficulty: 3)

        visit list_songs_path(view: "new")
        click_on "Easy"

        page.should have_content "#{song1.title}"
        page.should have_content "#{song2.title}"
        page.should_not have_content "#{song3.title}"
        page.should_not have_content "#{song4.title}"
      end

      it 'should show the medium songs' do
        song1 = create(:song, difficulty: 1)
        song2 = create(:song, difficulty: 2)
        song3 = create(:song, difficulty: 2)
        song4 = create(:song, difficulty: 3)

        visit list_songs_path(view: "new")
        click_on "Medium"

        page.should have_content "#{song2.title}"
        page.should have_content "#{song3.title}"
        page.should_not have_content "#{song1.title}"
        page.should_not have_content "#{song4.title}"
      end

      it 'should show the hard songs' do
        song1 = create(:song, difficulty: 1)
        song2 = create(:song, difficulty: 2)
        song3 = create(:song, difficulty: 3)
        song4 = create(:song, difficulty: 3)

        visit list_songs_path(view: "new")
        click_on "Hard"

        page.should have_content "#{song3.title}"
        page.should have_content "#{song4.title}"
        page.should_not have_content "#{song1.title}"
        page.should_not have_content "#{song2.title}"
      end
    end

    def check_filters
      page.should have_content 'Difficulty'
      page.should have_link 'All', list_songs_path(view: "my_songs", difficulty: 'all')
      page.should have_link 'Easy', list_songs_path(view: "my_songs", difficulty: 'easy')
      page.should have_link 'Medium', list_songs_path(view: "my_songs", difficulty: 'medium')
      page.should have_link 'Hard', list_songs_path(view: "my_songs", difficulty: 'hard')
    end
  end

  describe "user is not signed in" do
    it "should not display the my songs page" do
      visit list_songs_path(view: "my_songs")
      current_path.should eq(login_path)
    end

    it "should not display the most popular songs page" do
      visit list_songs_path(view: "most_popular")
      current_path.should eq(login_path)
    end

    it "should not display the new songs page" do
      visit list_songs_path(view: "new")
      current_path.should eq(login_path)
    end
  end

end