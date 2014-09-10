class ActivityCommentsController < ApplicationController
	before_action :authorize

	def index
	end

  def create
    @activity_comment = ActivityComment.new(activity_comment_params)
    @activity_comment.user = current_user

    respond_to do |format|
      format.html do
        if @activity_comment.save
          flash[:notice] = "Your comment was saved"
        else
          flash[:warning] = "Please write a comment"
        end
        redirect_to root_path
      end
      format.js do
        if @activity_comment.save
          render 'create.js'
        end
      end
    end
  end

	private

  def activity_comment_params
    params.require(:activity_comment).permit(:comment, :activity_id)
  end

end
