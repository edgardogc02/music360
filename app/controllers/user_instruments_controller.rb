class UserInstrumentsController < ApplicationController
	before_action :authorize

	def edit
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
      render "edit"
    end
  end

  private

  def user_instrument_params
    params.require(:user).permit(:instrument_id)
  end

end
