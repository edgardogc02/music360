class GroupChallengesController < ApplicationController
	before_action :authorize
  before_action :set_group

	def new
	  @challenge = GroupChallengeDecorator.decorate(@group.challenges.build)
    if params[:song_id].present?
      @challenge.song = Song.find(params[:song_id])
    end

    @songs = SongGroupChallengeDecorator.decorate_collection(Song.not_user_created.free.by_popularity.limit(4))
  end

  def show
    @challenge = GroupChallengeDecorator.decorate(Challenge.find(params[:id]))
    @results = @challenge.song_scores.includes(:user)
    @group_challenge_leaders = @challenge.song_scores.best_scores.limit(10)
    @posts = @challenge.group.posts.last(5)
    @group_leaders = @challenge.group.leader_users(10)
  end

  def create
    @challenge = @group.challenges.build(challenge_group_params)
    @challenge.challenger = current_user
    group_challenge_creation = GroupChallengeCreation.new(@challenge)

    if group_challenge_creation.save
      flash[:notice] = "The challenge was successfully created"
      redirect_to [@group, @challenge]
    else
      @songs = SongGroupChallengeDecorator.decorate_collection(Song.not_user_created.free.by_popularity.limit(4))
      flash.now[:warning] = ("There was an error when creating the challenge" + "<br/>" + @challenge.errors.full_messages.join(', ') + "<br/>" + "Please try again").html_safe
      render 'new'
    end
  end

  private

  def challenge_group_params
    params.require(:challenge).permit(:song_id, :challenged_id, :instrument, :public, :group_id)
  end

  def set_group
    @group = GroupDecorator.decorate(Group.find(params[:group_id]))
  end

end
