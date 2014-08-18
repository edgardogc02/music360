module PaginatedList

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