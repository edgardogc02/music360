class UserInstrumentsController < ApplicationController
	before_action :authorize

	def edit
	  @instruments = Instrument.visible
	  if !params[:next].blank?
	    @steps = create_onboarding_steps("Instrument")
	  end
	end

  def update
    if current_user.update_attributes(user_instrument_params)
      #flash[:notice] = "Your instrument was successfully updated"
      if !params[:next].blank?
        redirect_to tour_path
      else
        redirect_to overview_accounts_path
      end
    else
      @instruments = Instrument.visible
      flash.now[:warning] = "Something went wrong and your instrument was not updated. Please try again."
      render "edit"
    end
  end

  private

  def user_instrument_params
    params.require(:user).permit(:instrument_id)
  end

end
