require "spec_helper"

describe EmailNotifier do

  describe "send confirmation email" do
    let(:user) { create(:user) }
    let(:mail) { EmailNotifier.welcome_message(user) }

    it "sends user confirmation email" do
      mail.subject.should eq("Welcome to instrumentchamp.com")
      mail.to.should eq([user.email])
      mail.from.should eq(["no-reply@instrumentchamp.com"])
    end

    it "renders the body" do
      mail.body.encoded.should have_content "Hi #{user.username}, welcome to InstrumentChamp!"
      mail.body.encoded.should have_link "Challenge a friend", people_path
      mail.body.encoded.should have_link "Learn to play a song", songs_path
      mail.body.encoded.should have_link "Take the tour", tour_path
      mail.body.encoded.should have_link "Download the game", apps_path
      mail.body.encoded.should have_link "Get help", help_path
      mail.body.encoded.should have_content "Kind regards"
      mail.body.encoded.should have_content "The instrumentchamp team."
    end
  end

end
