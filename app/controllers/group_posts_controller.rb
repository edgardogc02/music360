class GroupPostsController < ApplicationController
	before_action :authorize
  before_action :set_group

	def new
  end

  def create
    @group_post = current_user.published_group_posts.build(group_params)
    @group_post.group = @group
    group_post_creation = GroupPostCreation.new(@group_post, current_user)

    if group_post_creation.save
      respond_to do |format|
        format.html do
          flash[:notice] = "Your post was successfully created"
          redirect_to @group
        end
        format.js { @group_post_activity = group_post_creation.activity }
      end
    else
      respond_to do |format|
        format.html do
          flash[:warning] = "Please write a message to post"
          redirect_to @group
        end
        format.js
      end
    end
  end

  private

  def group_params
    params.require(:group_post).permit(:message)
  end

  def set_group
    @group = GroupDecorator.decorate(Group.find(params[:group_id]))
  end

end
