class PostCommentsController < ApplicationController
	before_action :authorize

  before_action :load_comment

	def index
	end

  def create
    @post_comment = @commentable.comments.build(post_comment_params)
    @post_comment.user = current_user

    respond_to do |format|
      format.html do
        if @post_comment.save
          flash[:notice] = "Your comment was saved"
        else
          flash[:warning] = "Please write a comment"
        end
        if @commentable.kind_of?(GroupPost)
          redirect_to @commentable.group
        else
          redirect_to [@commentable.challenge.group, @commentable.challenge]
        end
      end
      format.js do
        if @post_comment.save
          if @commentable.kind_of?(GroupPost)
            @commentable_parent = @commentable.group
          else
            @commentable_parent = @commentable.challenge
          end
          render 'create.js'
        end
      end
    end
  end

	private

  def post_comment_params
    params.require(:post_comment).permit(:comment)
  end

  def load_comment
    klass = [GroupPost, ChallengePost].detect { |c| params["#{c.name.underscore}_id"] }
    @commentable = klass.find(params["#{klass.name.underscore}_id"])
  end

end
