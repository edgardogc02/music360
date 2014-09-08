class UserPostsController < ApplicationController
	before_action :authorize

	def new
  end

  def create
    @user_post = current_user.user_posts.build(user_post_params)
    user_post_creation = UserPostCreation.new(@user_post)

    if user_post_creation.save
      respond_to do |format|
        format.html do
          flash[:notice] = "Your post was successfully created"
          redirect_to home_path
        end
        format.js
      end
    else
      respond_to do |format|
        format.html do
          flash[:warning] = "Please write a message to post"
          redirect_to home_path
        end
        format.js
      end
    end
  end

  private

  def user_post_params
    params.require(:user_post).permit(:message)
  end

end
