require "spec_helper"

describe EmailNotifier do

  describe "send confirmation email" do
    let(:user) { create(:user) }
    let(:mail) { EmailNotifier.welcome_message(user) }

    it "sends user confirmation email" do
      mail.subject.should eq("Welcome to instrumentchamp.com")
      mail.to.should eq([user.email])
      mail.from.should eq(["no_reply@instrumentchamp.com"])
    end

    it "renders the body" do
      mail.body.encoded.should have_content("Welcome to instrumentchamp")
      mail.body.encoded.should have_content("Hi #{user.username}")
      mail.body.encoded.should have_content("Username: #{user.username}")
      mail.body.encoded.should have_content("Password: #{user.password}")
    end
  end

end
