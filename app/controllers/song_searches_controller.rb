class SongSearchesController < ApplicationController  
  before_action :authorize

  def modal_view_songs
    @songs = SongDecorator.decorate_collection(Song.free.by_popularity.limit(8))
    
    render 'modal', layout: false
  end

end
