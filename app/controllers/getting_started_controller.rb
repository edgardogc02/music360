class GettingStartedController < ApplicationController
	before_action :authorize

  layout "getting_started"

  def index
    @step = 1
  end

  def instrument_selection
    @instruments = Instrument.visible
    @step = 2
  end

  def music_players
    @popular_players = UserDecorator.decorate_collection(User.not_deleted.exclude(current_user).by_xp.limit(6))
    @step = 3
  end

  def music_challenges
    @song = Song.first
    @following_players = UserDecorator.decorate_collection(current_user.followed_users.by_xp.limit(6))
    @step = 4
  end

  def invite_friends
    @user_invitation = current_user.user_invitations.build
    @step = 5
  end

  def download
    @step = 6
  end

  private

  def group_params
    params.require(:group_post).permit(:message)
  end

end
