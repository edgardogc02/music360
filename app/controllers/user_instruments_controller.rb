class UserInstrumentsController < ApplicationController
	before_action :authorize

	def edit
	end

  def update
    if current_user.update_attributes(user_instrument_params)
      redirect_to person_path(current_user)
    else
      render "edit"
    end
  end

  private

  def user_instrument_params
    params.require(:user).permit(:instrument_id)
  end

end
