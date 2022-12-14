require 'spec_helper'

describe PaymentMethod do

  context "Validations" do
    [:name, :display_position, :html_id].each do |attr|
      it "should have validate presence of #{attr}" do
        should validate_presence_of(attr)
      end
    end

    it "should validate names are unique" do
     should validate_uniqueness_of(:name)
    end
  end

  context "Associations" do
    [:payments].each do |attr|
      it "should have many #{attr}" do
        should have_many(attr)
      end
    end
  end

  context "scopes" do
    it "should return the payment methods order by display_position" do
      paypal = create(:payment_method, display_position: 1)
      mobile = create(:payment_method, display_position: 3)
      credit_card = create(:payment_method, display_position: 2)

      PaymentMethod.default_order.should eq([paypal, credit_card, mobile])
    end
  end

end
