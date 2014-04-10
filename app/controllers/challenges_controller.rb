class ChallengesController < ApplicationController
	before_action :authorize

	def index
		@challenges = Challenge.public.open
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

  def yours
    @challenges = current_user.challenges
  end

	def create
	  @challenge = current_user.challenges.build(challenge_params)

	  if @challenge.save
	    redirect_to yours_challenges_path
	  else
	    render 'new'
	  end
	end

  def challenge_params
    params.require(:challenge).permit(:song_id, :challenged_id, :instrument, :public, :finished)
  end

end
