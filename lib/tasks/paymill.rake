require 'paymill'

namespace :paymill do
  desc "Import all subscription plans (Offers) from paymill"
  task import_plans: :environment do

    PremiumPlan.destroy_all

    offers = Paymill::Offer.all
    offers.each do |offer|
      PremiumPlan.create paymill_id: offer.id, name: offer.name, price: offer.amount / 100.0, currency: offer.currency
    end
  end

  task update_plans: :environment do
    offers = Paymill::Offer.all
    offers.each do |offer|
      premium_plan = PremiumPlan.find_by_paymill_id(offer.id)
      premium_plan.name = offer.name
      premium_plan.price = offer.amount / 100.0
      premium_plan.currency = offer.currency
      premium_plan.save
    end
  end
end