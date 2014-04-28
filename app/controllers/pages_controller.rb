class PagesController < ApplicationController
  before_action :authorize

  def home
    @song = Song.first.decorate
  end

  def download

  end
end
