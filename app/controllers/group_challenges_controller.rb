class GroupChallengesController < ApplicationController
	before_action :authorize, except: [:show]
  before_action :redirect_to_current_if_not_signed_in, only: [:show]
  before_action :set_group

	def index
	end

	def new
	  @challenge = GroupChallengeDecorator.decorate(@group.challenges.build)
    if params[:song_id].present?
      @challenge.song = Song.find(params[:song_id])
    end
    @songs = SongGroupChallengeDecorator.decorate_collection(Song.not_user_created.free.by_popularity.limit(4))
		@group_leaders = @challenge.group.leader_users(10)

    render layout: "detail"
  end

  def edit
    @challenge = GroupChallengeDecorator.decorate(Challenge.find(params[:id]))
  end

  def show
    @challenge = GroupChallengeDecorator.decorate(Challenge.find(params[:id]))
    @results = @challenge.song_scores.includes(:user)
    @group_challenge_leaders = @challenge.song_scores.best_scores
    @resumed_group_challenge_leaders = @challenge.song_scores.best_scores.limit(5)
    @challenge_activities = PublicActivity::Activity.where(challenge_id: @challenge.id).order('created_at DESC').limit(10)
    @group_leaders = @challenge.group.leader_users(10)

    render layout: "detail"
  end

  def create
    @challenge = GroupChallengeDecorator.decorate(@group.challenges.build(challenge_group_params))
    @challenge.challenger = current_user
    group_challenge_creation = GroupChallengeCreation.new(@challenge)

    if group_challenge_creation.save
      flash[:notice] = "The challenge was successfully created"
      redirect_to [@group, @challenge]
    else
      @songs = SongGroupChallengeDecorator.decorate_collection(Song.not_user_created.free.by_popularity.limit(4))
      flash.now[:warning] = ("There was an error when creating the challenge" + "<br/>" + @challenge.errors.full_messages.join(', ') + "<br/>" + "Please try again").html_safe
      render 'new', layout: 'detail'
    end
  end

  def update
    @challenge = Challenge.find(params[:id])

    if @challenge.update_attributes(challenge_group_params)
      redirect_to [@group, @challenge], notice: "The challenge was successfully updated"
    else
      render :edit
    end
  end

  private

  def challenge_group_params
    params.require(:challenge).permit(:song_id, :challenged_id, :instrument, :public, :group_id, :start_at, :description, :duration_in_days)
  end

  def set_group
    @group = GroupDecorator.decorate(Group.find(params[:group_id]))
  end

end
