require "spec_helper"

describe EmailNotifier do

  let(:host) { "https://www.instrumentchamp.com" }

  describe "send confirmation email" do
    let(:user) { create(:user) }
    let(:mail) { EmailNotifier.welcome_message(user) }

    it "sends user confirmation email" do
      mail.subject.should eq("Welcome to InstrumentChamp")
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

  describe "send user invitation email" do
    let(:user_invitation) { create(:user_invitation) }
    let(:mail) { EmailNotifier.user_invitation_message(user_invitation) }

    it "sends user invitation email" do
      mail.subject.should eq("Join InstrumentChamp")
      mail.to.should eq([user_invitation.friend_email])
      mail.from.should eq(["no-reply@instrumentchamp.com"])
    end

    it "renders the body" do
      mail.body.encoded.should have_content "Hi,"
      mail.body.encoded.should have_content "#{user_invitation.user.username} invited you to join InstrumentChamp."
    end
  end

  describe "send email to challenged user" do
    let(:challenge) { create(:challenge) }
    let(:mail) { EmailNotifier.challenged_user_message(challenge) }

    it "sends email to challenged user" do
      mail.subject.should eq("You have a new challenge on InstrumentChamp")
      mail.to.should eq([challenge.challenged.email])
      mail.from.should eq(["no-reply@instrumentchamp.com"])
    end

    it "renders the body" do
      mail.body.encoded.should have_content "Hi #{challenge.challenged.username},"
      mail.body.encoded.should have_content "#{challenge.challenger.username} has challenged you on InstrumentChamp."
      mail.body.encoded.should have_content "To view the challenge, you can click on the following link:"
      mail.body.encoded.should have_link challenge_url(challenge, host: host), challenge_url(challenge, host: host)
    end
  end

  describe "send email to followed user" do
    let(:user_follower) { create(:user_follower) }
    let(:mail) { EmailNotifier.followed_user_message(user_follower) }

    it "sends email to the followed user" do
      mail.subject.should eq("You have a new follower on InstrumentChamp")
      mail.to.should eq([user_follower.followed.email])
      mail.from.should eq(["no-reply@instrumentchamp.com"])
    end

    it "renders the body" do
      mail.body.encoded.should have_content "Hi #{user_follower.followed.username},"
      mail.body.encoded.should have_content "#{user_follower.follower.username} is following you on InstrumentChamp."
    end
  end
end
