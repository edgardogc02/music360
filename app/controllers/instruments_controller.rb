class InstrumentsController < ApplicationController
	before_action :authorize
  before_action :admin_only

  def index
    @instruments = Instrument.all
  end

	def edit
	  @instrument = Instrument.find(params[:id])
	end

  def update
    @instrument = Instrument.find(params[:id])
    if @instrument.update_attributes(instrument_params)
      redirect_to instruments_path
    else
      render "edit"
    end
  end

  private

  def instrument_params
    params.require(:instrument).permit(:image, :remote_image_url)
  end

  def admin_only
    redirect_to root_path unless current_user.admin?
  end
end
