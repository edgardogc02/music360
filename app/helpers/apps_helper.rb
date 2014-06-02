module AppsHelper

  def current_category(category, parameter)
    current = params[parameter]

    if (current == nil and category == nil) or
      (category != nil and current != nil and category.id == current.to_i)
      return "current"
    end
  end
  
  def display_instrument
    if current_user.has_instrument_selected?
      current_user.instrument.name
    else
      "instrument"
    end
  end
  
end
