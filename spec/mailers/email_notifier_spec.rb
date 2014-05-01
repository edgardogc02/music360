require "spec_helper"

describe EmailNotifier do

  describe "send confirmation email" do
    let(:user) { create(:user) }
    let(:mail) { EmailNotifier.welcome_message(user) }

    it "sends user confirmation email" do
      mail.subject.should eq("Welcome to instrumentchamp.com")
      mail.to.should eq([user.email])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      pending
      mail.body.encoded.should match(confirm_user_email_path(user.confirmation_code))
    end
  end

end
