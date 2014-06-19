class PremiumPlanDecorator < Draper::Decorator

  delegate_all

  def currency
    if model.currency == "EUR"
      h.content_tag :i, nil, {class: "glyphicon glyphicon-euro"}
    else
      h.content_tag :i, nil, {class: "glyphicon glyphicon-usd"}
    end
  end

end