class GroupActivitiesController < ApplicationController
	before_action :authorize
  before_action :set_group

	def index
	  @activities = PublicActivity::Activity.where(group_id: @group.id).order('created_at DESC').page(params[:page]).per(10)
    respond_to do |format|
      format.html
      format.js
    end
  end

  private

  def set_group
    @group = GroupDecorator.decorate(Group.find(params[:group_id]))
  end

end
