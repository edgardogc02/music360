class GroupsController < ApplicationController
	before_action :authorize
  before_action :set_group, only: [:show, :members, :join, :edit, :update]

  def index
    @my_groups = GroupDecorator.decorate_collection(current_user.groups.limit(5))
    @group_invitations = GroupDecorator.decorate_collection(current_user.groups_invited_to.limit(5))
#    @public_groups = GroupDecorator.decorate_collection(Group.public.limit(5))
#    @closed_groups = GroupDecorator.decorate_collection(Group.closed.limit(5))
#    @secret_groups = GroupDecorator.decorate_collection(Group.secret.limit(5))
  end

	def new
	  @group = Group.new
  end

  def edit
  end

  def show
    @posts = @group.posts.last(5)
  end

  def create
    @group = current_user.initiated_groups.build(group_params)
    group_creation = GroupCreation.new(@group, request)

    if group_creation.save
      redirect_to @group, notice: "The group was successfully created"
    else
      flash.now[:warning] = "Please enter a name and a privacy for the group"
      render :new
    end
  end

  def update
    if @group.update_attributes(group_params)
      redirect_to @group, notice: "The group was successfully updated"
    else
      flash.now[:warning] = "Please enter a name and a privacy for the group"
      render :edit
    end

  end

  def members
    @users = UserDecorator.decorate_collection(@group.users)
  end

  # TODO: REFACTOR (CREATE A NEW CONTROLLER FOR THIS? CREATE FORM FOR ACTION)
  def join
    user_group = current_user.user_groups.build(group: @group)

    if @group.secret? and !current_user.groups_invited_to_ids.include?(@group.id)
      flash[:warning] = "You can't join #{@group.name} because it's a secret group and you have no invitation."
      redirect_to groups_path
    else
      if group_invitation = current_user.group_invitations.by_group(@group.id).first
        group_invitation.destroy
      end
      if user_group.save
        redirect_to @group, notice: "You are now a member of #{@group.name}"
      else
        flash[:warning] = "You are already a member of #{@group.name}"
        redirect_to @group
      end
    end
  end

  private

  def group_params
    params.require(:group).permit(:name, :group_privacy_id, :imagename, :description)
  end

  def set_group
    @group = GroupDecorator.decorate(Group.find(params[:id]))
  end

end
