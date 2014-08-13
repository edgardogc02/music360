class GroupPostsController < ApplicationController
	before_action :authorize
  before_action :set_group

	def new
  end

  def create
    group_post = current_user.published_group_posts.build(group_params)
    group_post.group = @group

    if group_post.save
      group_post.create_activity :create, owner: current_user, group_id: @group.id
      flash[:notice] = "Your post was successfully created"
    else
      flash[:warning] = "Please write a message to post"
    end

    redirect_to @group
  end

  private

  def group_params
    params.require(:group_post).permit(:message)
  end

  def set_group
    @group = GroupDecorator.decorate(Group.find(params[:group_id]))
  end

end
