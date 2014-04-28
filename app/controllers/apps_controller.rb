class AppsController < ApplicationController

  before_action :authorize

  def index
    if params[:installed]
      current_user.already_installed_desktop_app
    end
  end

end
