class PostLikesController < ApplicationController
	before_action :authorize

  before_action :load_likeable

	def index
	end

  def create
    post_like = @likeable.likes.build(user: current_user)

    respond_to do |format|
      format.html do
        if post_like.save
          flash[:notice] = "You liked the post"
        else
          flash[:warning] = "You already liked that post"
        end
        if @likeable.kind_of?(GroupPost)
          redirect_to @likeable.group
        else
          redirect_to [@likeable.challenge.group, @likeable.challenge]
        end
      end
    end
  end

  def destroy
    @post_like = PostLike.find(params[:id])
    @post_like.destroy

    flash[:warning] = "You don't like this post anymore"
    if @likeable.kind_of?(GroupPost)
      redirect_to @likeable.group
    else
      redirect_to [@likeable.challenge.group, @likeable.challenge]
    end
  end

	private

  def load_likeable
    klass = [GroupPost, ChallengePost].detect { |c| params["#{c.name.underscore}_id"] }
    @likeable = klass.find(params["#{klass.name.underscore}_id"])
  end

end
