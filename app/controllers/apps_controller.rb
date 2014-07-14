class AppsController < ApplicationController

  before_action :authorize, except: [:index]

  def index
    if params[:installed]
      current_user.already_installed_desktop_app
    end
    if params[:song_id]
      current_user.update_first_song(params[:song_id])
    end
    if params[:challenge_id]
      current_user.update_first_challenge(params[:challenge_id])
    end
  end

end
