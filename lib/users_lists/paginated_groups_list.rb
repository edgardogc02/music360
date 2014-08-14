class PaginatedGroupsList < GroupsList

  def initialize(page="")
    @page = page
  end

  def paginate?
    true
  end

  def page
    @page
  end

end