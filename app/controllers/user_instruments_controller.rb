class UserInstrumentsController < ApplicationController
	before_action :authorize

	def edit
	  @instruments = Instrument.visible.all
	  if !params[:next].blank?
	    @steps = create_onboarding_steps("Instrument")
	  end
	end

  def update
    if current_user.update_attributes(user_instrument_params)
      flash[:notice] = "Your instrument was successfully updated"
      if !params[:next].blank?
        redirect_to [params[:next].to_sym]
      else
        redirect_to person_path(current_user)
      end
    else
      @instruments = Instrument.visible.all
      flash.now[:warning] = "Something went wrong and your instrument was not updated. Please try again."
      render "edit"
    end
  end

  private

  def user_instrument_params
    params.require(:user).permit(:instrument_id)
  end

end
