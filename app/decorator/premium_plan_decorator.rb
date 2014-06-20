class PremiumPlanDecorator < Draper::Decorator

  delegate_all

  def currency
    if model.currency == "EUR"
      h.content_tag :i, nil, {class: "glyphicon glyphicon-euro"}
    else
      h.content_tag :i, nil, {class: "glyphicon glyphicon-usd"}
    end
  end
  
  def price_per_month
    (model.price / model.duration_in_months).to_f
  end
  
  def save_percentage
    monthly_price = PremiumPlan.one_month_plan.price
    save = (((monthly_price - price_per_month) / monthly_price) * 100).round # (((model.price - price_per_month) / price_per_month) * 100).round
    class_attr = "plan-save"
    if save == 0
      class_attr << " no-visible"
    end 
    h.content_tag :span, '(save ' + save.to_s + '%)', {class: class_attr}   
  end

end