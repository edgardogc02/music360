class GroupsController < ApplicationController
	before_action :authorize, except: [:show]
	before_action :redirect_to_current_if_not_signed_in, only: [:show]
  before_action :set_group, only: [:show, :members, :join, :edit, :update, :challenges, :leaderboard, :destroy]

  def index
    @group_invitations = GroupDecorator.decorate_collection(current_user.groups_invited_to.limit(5))
  	@my_groups = ResumedMyGroupsList.new(current_user)
    @most_popular_groups = ResumedMostPopularGroupsList.new(current_user)
    @new_groups = ResumedNewGroupsList.new(current_user)
  end

	def new
	  @group = Group.new
  end

  def edit
  end

  def show
    @group_leaders = @group.leader_users(10)
    @group_activities = PublicActivity::Activity.where(group_id: @group.id).order('created_at DESC').page(1).per(10)

    render layout: "detail"
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
    group_update = GroupUpdate.new(@group, current_user)

    if group_update.save(group_params)
      redirect_to @group, notice: "The group was successfully updated"
    else
      flash.now[:warning] = "Please enter a name and a privacy for the group"
      render :edit
    end

  end

  def members
    @users = UserDecorator.decorate_collection(@group.users)
    @group_leaders = @group.leader_users(10)

    render layout: "detail"
  end

  def challenges
    @open_challenges = GroupChallengeDecorator.decorate_collection(@group.challenges.open.started)
    @finished_challenges = GroupChallengeDecorator.decorate_collection(@group.challenges.finished)
  	@group_leaders = @group.leader_users(10)

  	render layout: "detail"
  end

  def leaderboard
  	@group_leaders = UserDecorator.decorate_collection(@group.leader_users(10))

  	render layout: "detail"
  end

	def list
    @groups = GroupsListFactory.new(params[:view], current_user, params[:page]).groups_list
  end

  # TODO: REFACTOR (CREATE A NEW CONTROLLER FOR THIS? CREATE FORM FOR ACTION)
  def join
    user_group = current_user.user_groups.build(group: @group)
    group_invitation = current_user.group_invitations.by_group(@group.id).first

    if @group.public?

      if group_invitation
        group_invitation.destroy
      end
      if user_group.save
        @group.create_activity :join, owner: current_user, group_id: @group.id
        @group.assign_xp_to_owner_after_new_member_joins
        redirect_to @group, notice: "You are now a member of #{@group.name}"
      else
        flash[:warning] = "You are already a member of #{@group.name}"
        redirect_to @group
      end

    elsif @group.closed?

      if group_invitation
        if group_invitation.inviter_user == @group.initiator_user # invited by admin user
          group_invitation.destroy

          if user_group.save
            @group.create_activity :join, owner: current_user, group_id: @group.id
            @group.assign_xp_to_owner_after_new_member_joins
            redirect_to @group, notice: "You are now a member of #{@group.name}"
          else
            flash[:warning] = "You are already a member of #{@group.name}"
            redirect_to @group
          end

        else # invited by a regular user
          group_invitation.pending_approval = true
          group_invitation.save

          redirect_to @group, notice: "You'll be accepted as a group member when your membership request has been processed by an admin user of this group"
        end
      else
        if UserGroupsManager.new(current_user).belongs_to_group?(@group)
          flash[:warning] = "You are already a member of #{@group.name}"
          redirect_to @group
        else
          group_invitation = current_user.group_invitations.build
          group_invitation.group = @group
          group_invitation.pending_approval = true
          group_invitation.save

          redirect_to @group, notice: "You'll be accepted as a group member when your membership request has been processed by an admin user of this group"
        end
      end

    elsif @group.secret?

      if group_invitation

        if group_invitation.inviter_user == @group.initiator_user # invited by admin user
          group_invitation.destroy

          if user_group.save
            @group.create_activity :join, owner: current_user, group_id: @group.id
            @group.assign_xp_to_owner_after_new_member_joins
            redirect_to @group, notice: "You are now a member of #{@group.name}"
          else
            flash[:warning] = "You are already a member of #{@group.name}"
            redirect_to @group
          end
        else
          group_invitation.pending_approval = true
          group_invitation.save

          redirect_to @group, notice: "You'll be accepted as a group member when your membership request has been processed by an admin user of this group"
        end
      else
        flash[:warning] = "You can't join #{@group.name} because it's a secret group and you have no invitation."
        redirect_to @group
      end
    end

  end

  private

  def group_params
    params.require(:group).permit(:name, :group_privacy_id, :imagename, :description, :cover)
  end

  def set_group
    @group = GroupDecorator.decorate(Group.find(params[:id]))
  end

end
