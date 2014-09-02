class NewGroupsList < PaginatedGroupsList

  include Rails.application.routes.url_helpers

  def initialize(page, current_user)
    @current_user = current_user
    super(page)
  end

  def display_more?
    false
  end

  def title
    "New"
  end

  def current_user
    @current_user
  end

  def groups
    @groups ||= GroupDecorator.decorate_collection(Group.where(id: not_secret_groups + user_secret_groups).by_creation_date.limit(6).page(page))
  end

  private

  def not_secret_groups
    @not_secret_gropus ||= Group.not_secret.by_creation_date
  end

  def user_secret_groups
    @user_secret_gropus ||= current_user.groups.secret.by_creation_date
  end

end