module AppsHelper

  def current_category(category, parameter)
    current = params[parameter]

    if (current == nil and category == nil) or
      (category != nil and current != nil and category.id == current.to_i)
      return "current"
    end
  end

end
