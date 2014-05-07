class ChallengesController < ApplicationController
	before_action :authorize, except: [:index, :show]

	def index
		@challenges = ChallengeDecorator.decorate_collection(Challenge.order('created_at DESC')) # TODO: ADD public
	end

	def new
	  @challenge = current_user.challenges.build(public: false, finished: false)

		if params[:challenged_id].present?
			@challenge.challenged = User.find(params[:challenged_id])
		end
		if params[:song_id].present?
		  @challenge.song = Song.find(params[:song_id])
		end
	end

  def show
    @challenge = Challenge.find(params[:id])
  end

  def yours
    @challenges = ChallengeDecorator.decorate_collection(current_user.challenges)

    if params[:autostart_challenge_id]
      @autostart_challenge = Challenge.find(params[:autostart_challenge_id])
    end
  end

	def create
	  @challenge = current_user.challenges.build(challenge_params)

	  if @challenge.save
	    flash[:notice] = "The challenge was successfully created"
	    redirect_to yours_challenges_path(autostart_challenge_id: @challenge.id)
	  else
	    flash.now[:warning] = ("There was an error when creating the challenge" + "<br/>" + @challenge.errors.full_messages.join(', ') + "<br/>" + "Please try again").html_safe
	    render 'new'
	  end
	end

  def challenge_params
    params.require(:challenge).permit(:song_id, :challenged_id, :instrument, :public, :finished)
  end

end
