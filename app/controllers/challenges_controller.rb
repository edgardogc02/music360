class ChallengesController < ApplicationController
	before_action :authorize, except: [:show]

	def index
		@my_challenges = TabMyChallengesDecorator.decorate(Challenge.not_played_by_user(current_user, Challenge.default_order.default_limit.values))
    @pending_challenges = TabPendingChallengesDecorator.decorate(Challenge.pending_for_user(current_user, Challenge.default_order.default_limit.values))
		@challenges_results = TabResultChallengesDecorator.decorate(Challenge.results_for_user(current_user, Challenge.default_order.default_limit.values))
	end

	def new
	  @challenge = ChallengeDecorator.decorate(current_user.challenges.build(public: false))

		if params[:challenged_id].present?
			@challenge.challenged = User.find(params[:challenged_id])
		end
		if params[:song_id].present?
		  @challenge.song = Song.find(params[:song_id])
		end

		prepopulate_challenge_if_needed

		@songs = SongChallengeDecorator.decorate_collection(Song.free.by_popularity.limit(4))
	end

  def show
    if !signed_in?
      session[:prepopulate_with_challenge_id] = params[:id]
    end
    @challenge = Challenge.find(params[:id]).decorate
  end

  def yours
    @challenges = ChallengeDecorator.decorate_collection(current_user.challenges.default_order)

    if params[:autostart_challenge_id]
      @autostart_challenge = Challenge.find(params[:autostart_challenge_id])

      if display_fb_popup?
        @open_fb_notification_popup = true
      end
    end
  end

  def list
    if params[:view] == "my_challenges"
      @challenges = ChallengesDecorator.decorate(Challenge.not_played_by_user(current_user, Challenge.default_order.values))
      @title = "My challenges"
    elsif params[:view] == "pending"
      @challenges = ChallengesDecorator.decorate(Challenge.pending_for_user(current_user, Challenge.default_order.values))
      @title = "Open challenges"
    elsif params[:view] == "results"
      @challenges = ChallengesDecorator.decorate(Challenge.results_for_user(current_user, Challenge.default_order.values))
      @title = "Results"
    end
  end

	def create
	  @challenge = current_user.challenges.build(challenge_params).decorate
	  challenge_completition = ChallengeCreation.new(@challenge)

	  if challenge_completition.save
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

  def destroy
    @challenge = Challenge.find(params[:id])
    if @challenge.destroy
      flash[:notice] = "The challenge was declined"
    else
      flash[:notice] = "The challenge could not be declined. Please try again later."
    end
    redirect_to challenges_path
  end

  private

  def challenge_params
    params.require(:challenge).permit(:song_id, :challenged_id, :instrument, :public)
  end

  def display_fb_popup?
    params[:send_fb_notification] and @autostart_challenge.challenged.connected_with_facebook? and current_user.has_facebook_credentials?
  end

  def prepopulate_challenge_if_needed
    if session[:prepopulate_with_challenge_id]
      challenge = Challenge.find(session[:prepopulate_with_challenge_id])
      if !challenge.is_user_involved?(current_user)
        @challenge.challenged = challenge.challenged
        @challenge.song = challenge.song
      end
      session[:prepopulate_with_challenge_id] = nil
    end
  end

end
