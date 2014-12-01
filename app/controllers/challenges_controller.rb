class ChallengesController < ApplicationController
	before_action :authorize, except: [:show]
	before_action :redirect_to_current_if_not_signed_in, only: [:show]

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

		@songs = SongChallengeDecorator.decorate_collection(current_user.song_selection_for_challenge(12))
		@users = UserChallengeDecorator.decorate_collection(current_user.users_for_challenge(12))
	end

  def show
    if !signed_in?
      session[:prepopulate_with_challenge_id] = params[:id]
    end
    @challenge = Challenge.find(params[:id]).decorate
    @challenge_activities = PublicActivity::Activity.where(challenge_id: @challenge.id).order('created_at DESC').limit(10)

    render layout: "detail"
  end

  def yours
    @challenges = ChallengeDecorator.decorate_collection(current_user.challenges.default_order.page params[:page])
    if params[:autostart_challenge_id]
      @autostart_challenge = Challenge.find(params[:autostart_challenge_id])

      if display_fb_popup?
        @open_fb_notification_popup = true
      end
    end
  end

  def list
    if params[:view] == "my_challenges"
      @challenges = Kaminari.paginate_array(ChallengeDecorator.decorate_collection(Challenge.not_played_by_user(current_user, Challenge.default_order.values))).page(params[:page]).per(9)
      @title = "My challenges"
      @paginate = true
    elsif params[:view] == "pending"
      @challenges = Kaminari.paginate_array(ChallengeDecorator.decorate_collection(Challenge.pending_for_user(current_user, Challenge.default_order.values))).page(params[:page]).per(9)
      @title = "Open challenges"
      @paginate = true
    elsif params[:view] == "results"
      @challenges = ChallengeDecorator.decorate_collection(Kaminari.paginate_array(Challenge.results_for_user(current_user, Challenge.default_order.values)).page(params[:page])).per(9)
      @title = "Results"
      @paginate = true
    elsif params[:view] == "new"
      @challenges = ChallengeDecorator.decorate_collection(Challenge.all.default_order.page params[:page])
      @title = "New"
      @paginate = true
    elsif params[:view] == "most_popular"
      @challenges = ChallengeDecorator.decorate_collection(Challenge.by_popularity.page(params[:page]))
      @title = "Most popular"
      @paginate = true
    end
  end

	def create
	  @challenge = current_user.challenges.build(challenge_params).decorate
	  challenge_completition = ChallengeCreation.new(@challenge)

	  if challenge_completition.save
	    flash[:notice] = "The challenge was successfully created"
	    redirect_to yours_challenges_path(autostart_challenge_id: @challenge.id, send_fb_notification: 1)
	  else
	    @songs = SongChallengeDecorator.decorate_collection(current_user.song_selection_for_challenge(12))
	    @users = UserChallengeDecorator.decorate_collection(current_user.users_for_challenge(12))
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
    params[:send_fb_notification] and
      UserFacebookAccount.new(current_user).connected? and
      UserFacebookFriend.friends?(@autostart_challenge.challenger, @autostart_challenge.challenged)
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
