require 'spec_helper'

describe PaymentType do

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
    it "should have many payments" do
      should have_many(:payments)
    end
  end

  context "scopes" do
    it "should return the payment types order by display_position" do
      paypal = create(:payment_type, display_position: 1)
      mobile = create(:payment_type, display_position: 3)
      credit_card = create(:payment_type, display_position: 2)

      PaymentType.default_order.should eq([paypal, credit_card, mobile])
    end
  end

end
