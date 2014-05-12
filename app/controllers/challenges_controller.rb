class ChallengesController < ApplicationController
	before_action :authorize, except: [:show]

	def index
		@my_challenges = @challenges = ChallengeDecorator.decorate_collection(current_user.challenges.order('created_at DESC').limit(3))
		@open_challenges = ChallengeDecorator.decorate_collection(Challenge.open.order('created_at DESC').limit(3))
		@challenges = ChallengeDecorator.decorate_collection(Challenge.order('created_at DESC').limit(3)) # TODO: ADD public
		@challenges_results = ChallengeDecorator.decorate_collection(Challenge.has_result.order('created_at DESC').limit(3))
	end

	def new
	  @challenge = ChallengeDecorator.decorate(current_user.challenges.build(public: false, finished: false))

		if params[:challenged_id].present?
			@challenge.challenged = User.find(params[:challenged_id])
		end
		if params[:song_id].present?
		  @challenge.song = Song.find(params[:song_id])
		end
	end

  def show
    @challenge = Challenge.find(params[:id]).decorate
  end

  def yours
    @challenges = ChallengeDecorator.decorate_collection(current_user.challenges.order('created_at DESC'))

    if params[:autostart_challenge_id]
      @autostart_challenge = Challenge.find(params[:autostart_challenge_id])

      if params[:send_fb_notification] and @autostart_challenge.challenged.fake_facebook_user?
        @open_fb_notification_popup = true
      end
    end
  end

  def list
    if params[:view] == "my_challenges"
      @challenges = ChallengeDecorator.decorate_collection(current_user.challenges.order('created_at DESC'))
      @title = "My challenges"

      if params[:autostart_challenge_id]
        @autostart_challenge = Challenge.find(params[:autostart_challenge_id])
      end
    elsif params[:view] == "open"
      @challenges = ChallengeDecorator.decorate_collection(Challenge.open.order('created_at DESC'))
      @title = "Open challenges"
    elsif params[:view] == "all"
      @challenges = ChallengeDecorator.decorate_collection(Challenge.order('created_at DESC'))
      @title = "All challenges"
    elsif params[:view] == "results"
      @challenges = ChallengeDecorator.decorate_collection(Challenge.has_result.order('created_at DESC'))
      @title = "Results"
    end
  end

	def create
	  @challenge = current_user.challenges.build(challenge_params).decorate

	  if @challenge.save_and_follow_challenged
	    flash[:notice] = "The challenge was successfully created"
	    redirect_to yours_challenges_path(autostart_challenge_id: @challenge.id, send_fb_notification: 1)
	  else
	    flash.now[:warning] = ("There was an error when creating the challenge" + "<br/>" + @challenge.errors.full_messages.join(', ') + "<br/>" + "Please try again").html_safe
	    render 'new'
	  end
	end

	def update
	  @challenge = Challenge.find(params[:id])
    if @challenge.update_attributes(challenge_params)
      redirect_to challenges_path, notice: "Your profile was successfully updated"
    else
      flash.now[:warning] = "Check the errors below and try again"
      redirect_to challenges_path
    end
  end

  def challenge_params
    params.require(:challenge).permit(:song_id, :challenged_id, :instrument, :public, :finished)
  end

end
