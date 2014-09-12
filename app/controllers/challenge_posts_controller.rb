class ChallengePostsController < ApplicationController
	before_action :authorize
  before_action :set_challenge

	def new
  end

  def create
    @challenge_post = current_user.published_challenge_posts.build(challenge_params)
    @challenge_post.challenge = @challenge
    challenge_post_creation = ChallengePostCreation.new(@challenge_post, current_user)

    if challenge_post_creation.save
      respond_to do |format|
        format.html do
          flash[:notice] = "Your post was successfully created"
          redirect_to [@challenge.group, @challenge]
        end
        format.js { @challenge_post_activity = challenge_post_creation.activity }
      end
    else
      respond_to do |format|
        format.html do
          flash[:warning] = "Please write a message to post"
          redirect_to [@challenge.group, @challenge]
        end
        format.js
      end
    end
  end

  private

  def challenge_params
    params.require(:challenge_post).permit(:message)
  end

  def set_challenge
    @challenge = ChallengeDecorator.decorate(Challenge.find(params[:challenge_id]))
  end

end
