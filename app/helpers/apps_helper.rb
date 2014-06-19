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

  def windows_download_link
    if signed_in? and current_user.american?
      "https://s3-us-west-2.amazonaws.com/instrumentchamp/InstrumentChamp.msi"
    else
      "https://s3-eu-west-1.amazonaws.com/ic-eu/InstrumentChamp.msi"
    end
  end

  def mac_download_link
    if signed_in? and current_user.american?
      "https://s3-us-west-2.amazonaws.com/instrumentchamp/InstrumentChamp_Band_Edition.dmg"
    else
      "https://s3-eu-west-1.amazonaws.com/ic-eu/InstrumentChamp_Band_Edition.dmg"
    end
  end

end
