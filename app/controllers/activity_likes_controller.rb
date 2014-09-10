class ActivityLikesController < ApplicationController
	before_action :authorize

  before_action :load_activity, except: [:destroy]

  def create
    activity_like = @activity.likes.build(user: current_user)

    respond_to do |format|
      format.html do
        if activity_like.save
          flash[:notice] = "You liked this feed"
        else
          flash[:warning] = "You already liked that feed"
        end
        redirect_to root_path
      end
      format.js do
        if activity_like.save
          render 'create.js.erb'
        end
      end
    end
  end

  def destroy
    @activity_like = ActivityLike.find(params[:id])
    @activity = @activity_like.activity
    @activity_like.destroy

    respond_to do |format|
      format.html do
        flash[:warning] = "You don't like this feed anymore"
      end
      format.js do
        render 'create.js.erb'
      end
    end
  end

	private

  def load_activity
    @activity = PublicActivity::Activity.find(params[:activity_id].to_i)
  end

end
