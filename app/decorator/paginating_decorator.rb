class PaginatingDecorator < Draper::CollectionDecorator
  include Draper::AutomaticDelegation # delegates all to parent class. ie, delegates all missing methods to activerecord model class

  delegate :current_page, :total_pages, :limit_value

  def decorated_object
    object
  end

end