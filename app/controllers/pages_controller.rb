class PagesController < ApplicationController
  before_action :authorize

  def home
    @song = Song.first
  end

  def download

  end
end
