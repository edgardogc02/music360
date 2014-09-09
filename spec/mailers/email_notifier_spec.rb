require "spec_helper"

describe EmailNotifier do

  let(:host) { "https://www.instrumentchamp.com" }

  describe "send welcome email without password" do
    let(:user) { create(:user) }
    let(:mail) { EmailNotifier.welcome_message(user) }

    it "sends user welcome email" do
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
      check_greeting_lines
    end
  end

  describe "send welcome email with password" do
    let(:user) { create(:user) }
    let(:mail) { EmailNotifier.welcome_message(user, true) }

    it "sends user welcome email" do
      mail.subject.should eq("Welcome to InstrumentChamp")
      mail.to.should eq([user.email])
      mail.from.should eq(["no-reply@instrumentchamp.com"])
    end

    it "renders the body" do
      mail.body.encoded.should have_content "Hi #{user.username}, welcome to InstrumentChamp!"
      mail.body.encoded.should have_content "This is your account information:"
      mail.body.encoded.should have_content "Username: #{user.username}"
      mail.body.encoded.should have_content "Password: #{user.password}"
      mail.body.encoded.should have_link "Challenge a friend", people_path
      mail.body.encoded.should have_link "Learn to play a song", songs_path
      mail.body.encoded.should have_link "Take the tour", tour_path
      mail.body.encoded.should have_link "Download the game", apps_path
      mail.body.encoded.should have_link "Get help", help_path
      mail.body.encoded.should have_content "Kind regards"
      mail.body.encoded.should have_content "The instrumentchamp team."
      check_greeting_lines
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
      check_greeting_lines
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
      mail.body.encoded.should have_link challenge_url(challenge, host: challenge.challenger.created_by), challenge_url(challenge, host: challenge.challenger.created_by)
      mail.body.encoded.should have_content "Kind regards,"
      mail.body.encoded.should have_content "The instrumentchamp team."
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
      check_greeting_lines
    end
  end

  describe "send reminder email to challenged user" do
    let(:challenge) { create(:challenge) }
    let(:mail) { EmailNotifier.remind_challenged_user(challenge) }

    it "sends reminder email to challenged user" do
      mail.subject.should eq("Challenge reminder on InstrumentChamp")
      mail.to.should eq([challenge.challenged.email])
      mail.from.should eq(["no-reply@instrumentchamp.com"])
    end

    it "renders the body" do
      mail.body.encoded.should have_content "Hi #{challenge.challenged.username},"
      mail.body.encoded.should have_content "we remind you that #{challenge.challenger.username} has challenged you on InstrumentChamp."
      mail.body.encoded.should have_content "To play the challenge, you can click on the following link:"
      mail.body.encoded.should have_link challenge_url(challenge, host: challenge.challenged.created_by), challenge_url(challenge, host: challenge.challenged.created_by)
      check_greeting_lines
    end
  end

  describe "send reminder email to challenger user" do
    let(:challenge) { create(:challenge) }
    let(:mail) { EmailNotifier.remind_challenger_user(challenge) }

    it "sends reminder email to challenger user" do
      mail.subject.should eq("Challenge reminder on InstrumentChamp")
      mail.to.should eq([challenge.challenger.email])
      mail.from.should eq(["no-reply@instrumentchamp.com"])
    end

    it "renders the body" do
      mail.body.encoded.should have_content "Hi #{challenge.challenger.username},"
      mail.body.encoded.should have_content "you challenged #{challenge.challenged.username} on InstrumentChamp, but you haven't played it yet."
      mail.body.encoded.should have_content "To play the challenge, you can click on the following link:"
      mail.body.encoded.should have_link challenge_url(challenge, host: challenge.challenger.created_by), challenge_url(challenge, host: challenge.challenger.created_by)
      check_greeting_lines
    end
  end

  describe "send purchased song email" do
    let(:user) { create(:user) }
    let(:user_purchased_song) { create(:user_purchased_song, user: user) }
    let(:payment) { create(:payment, user: user) }
    let(:mail) { EmailNotifier.purchased_song_message(user_purchased_song, payment) }

    it "sends purchased song email to buyer user" do
      mail.subject.should eq("Your purchase on InstrumentChamp")
      mail.to.should eq([user.email])
      mail.from.should eq(["no-reply@instrumentchamp.com"])
    end

    it "renders the body" do
      mail.body.encoded.should have_content "Hi #{user.username},"
      mail.body.encoded.should have_content "You have successfully purchased a song on InstrumentChamp. You can see more details below:"
      mail.body.encoded.should have_content "Song: #{user_purchased_song.song.title} by #{user_purchased_song.song.artist.title}"
      mail.body.encoded.should have_content "Payment amount: #{payment.amount} #{payment.currency}"
      mail.body.encoded.should have_content "Payment method: #{payment.payment_method.name}"
      mail.body.encoded.should have_content "To play the song, you can click on the following link:"
      mail.body.encoded.should have_link song_url(user_purchased_song.song, host: user_purchased_song.user.created_by), song_url(user_purchased_song.song, host: user_purchased_song.user.created_by)
      check_greeting_lines
    end
  end

  describe "send purchased premium subscription email" do
    let(:user) { create(:user) }
    let(:user_premium_subscription) { create(:user_premium_subscription, user: user) }
    let(:payment) { user_premium_subscription.payment }
    let(:mail) { EmailNotifier.user_premium_subscription_message(user_premium_subscription) }

    it "sends purchased premium subscription email to buyer user" do
      mail.subject.should eq("Your premium subscription to InstrumentChamp")
      mail.to.should eq([user.email])
      mail.from.should eq(["no-reply@instrumentchamp.com"])
    end

    it "renders the body" do
      mail.body.encoded.should have_content "Hi #{user.username},"
      mail.body.encoded.should have_content "You have successfully purchased a premium subscription on InstrumentChamp. You can see more details below:"
      mail.body.encoded.should have_content "Subscription: #{user_premium_subscription.premium_plan.name}"
      mail.body.encoded.should have_content "Payment amount: #{payment.amount} #{payment.currency}"
      mail.body.encoded.should have_content "Payment method: #{payment.payment_method.name}"
      check_greeting_lines
    end
  end

  describe "send premium subscription cancellation email" do
    let(:user) { create(:user) }
    let(:user_premium_subscription) { create(:user_premium_subscription, user: user) }
    let(:mail) { EmailNotifier.user_premium_subscription_cancellation_message(user_premium_subscription) }

    it "sends premium subscription cancellation email to buyer user" do
      mail.subject.should eq("Premium subscription cancellation")
      mail.to.should eq([user.email])
      mail.from.should eq(["no-reply@instrumentchamp.com"])
    end

    it "renders the body" do
      mail.body.encoded.should have_content "Hi #{user.username},"
      mail.body.encoded.should have_content "You have successfully cancelled your premium subscription on InstrumentChamp"
      check_greeting_lines
    end
  end

  describe "send premium subscription renewal email" do
    let(:user) { create(:user) }
    let(:user_premium_subscription) { create(:user_premium_subscription, user: user) }
    let(:payment) { user_premium_subscription.payment }
    let(:mail) { EmailNotifier.user_premium_subscription_renewal_message(user_premium_subscription) }

    it "sends premium subscription renewal email to buyer user" do
      mail.subject.should eq("Premium subscription renewal")
      mail.to.should eq([user.email])
      mail.from.should eq(["no-reply@instrumentchamp.com"])
    end

    it "renders the body" do
      mail.body.encoded.should have_content "Hi #{user.username},"
      mail.body.encoded.should have_content "Your premium subscription on InstrumentChamp has been renewed. You can see below your payment details:"
      mail.body.encoded.should have_content "Subscription: #{user_premium_subscription.premium_plan.name}"
      mail.body.encoded.should have_content "Payment amount: #{payment.amount} #{payment.currency}"
      mail.body.encoded.should have_content "Payment method: #{payment.payment_method.name}"
      check_greeting_lines
    end
  end

  describe "send premium subscription renewal alert email" do
    let(:user) { create(:user) }
    let(:user_premium_subscription) { create(:user_premium_subscription, user: user) }
    let(:payment) { user_premium_subscription.payment }
    let(:mail) { EmailNotifier.user_premium_subscription_renewal_alert_message(user_premium_subscription) }

    it "sends premium subscription renewal alert email to buyer user" do
      mail.subject.should eq("Premium subscription renewal alert")
      mail.to.should eq([user.email])
      mail.from.should eq(["no-reply@instrumentchamp.com"])
    end

    it "renders the body" do
      mail.body.encoded.should have_content "Hi #{user.username},"
      mail.body.encoded.should have_content "Your premium subscription on InstrumentChamp is going to be automatically renewed. You can see below your payment details:"
      mail.body.encoded.should have_content "Subscription: #{user_premium_subscription.premium_plan.name}"
      mail.body.encoded.should have_content "Payment amount: #{payment.amount} #{payment.currency}"
      mail.body.encoded.should have_content "Payment method: #{payment.payment_method.name}"
      check_greeting_lines
    end
  end

  describe "send group invitation message email" do
    let(:group_invitation) { create(:group_invitation) }
    let(:mail) { EmailNotifier.group_invitation_message(group_invitation) }

    it "sends group invitation message to the invited user" do
      mail.subject.should eq("Group invitation")
      mail.to.should eq([group_invitation.user.email])
      mail.from.should eq(["no-reply@instrumentchamp.com"])
    end

    it "renders the body" do
      mail.body.encoded.should have_content "Hi #{group_invitation.user.username},"
      mail.body.encoded.should have_content "you were invited you to join \"#{group_invitation.group.name}\" group on InstrumentChamp."
      mail.body.encoded.should have_link "Join", join_group_url(group_invitation.group, host: group_invitation.user.created_by)
      check_greeting_lines
    end
  end

  describe "send group invitation acceptance email" do
    let(:user_group) { create(:user_group) }
    let(:mail) { EmailNotifier.group_invitation_accepted(user_group) }

    it "sends group invitation acceptance message to the invited user" do
      mail.subject.should eq("Your group membership was accepted")
      mail.to.should eq([user_group.user.email])
      mail.from.should eq(["no-reply@instrumentchamp.com"])
    end

    it "renders the body" do
      mail.body.encoded.should have_content "Hi #{user_group.user.username},"
      mail.body.encoded.should have_content "you are now a member of \"#{user_group.group.name}\" on InstrumentChamp."
      mail.body.encoded.should have_link "Visit group", group_url(user_group.group, host: user_group.user.created_by)
      check_greeting_lines
    end
  end

  describe "send group invitation rejected email" do
    let(:user) { create(:user) }
    let(:group) { create(:group) }
    let(:mail) { EmailNotifier.group_invitation_rejected(user, group) }

    it "sends group invitation acceptance message to the invited user" do
      mail.subject.should eq("Your group membership was rejected")
      mail.to.should eq([user.email])
      mail.from.should eq(["no-reply@instrumentchamp.com"])
    end

    it "renders the body" do
      mail.body.encoded.should have_content "Hi #{user.username},"
      mail.body.encoded.should have_content "your membership to \"#{group.name}\" was rejected."
      check_greeting_lines
    end
  end

  describe "send group challenge created email" do
    let(:user) { create(:user) }
    let(:group_challenge) { create(:group_challenge) }
    let(:mail) { EmailNotifier.group_challenge_created(group_challenge, user).deliver }

    it "sends group challenge created message to a member user" do
      mail.subject.should eq("New group challenge created")
      mail.to.should eq([user.email])
      mail.from.should eq(["no-reply@instrumentchamp.com"])
    end

    it "renders the body" do
      mail.body.encoded.should have_content "Hi #{user.username},"
      mail.body.encoded.should have_content "There is a new group challenge on \"#{group_challenge.group.name}\" on InstrumentChamp."
      mail.body.encoded.should have_content "To view the challenge, you can click on the following link:"
      mail.body.encoded.should have_link "View challenge", group_challenge_url(group_id: group_challenge.group_id, id: group_challenge.id, host: user.created_by)
      check_greeting_lines
    end
  end

  describe "send group challenge final position email" do
    let(:song_score) { create(:song_score, challenge: create(:group_challenge)) }
    let(:mail) { EmailNotifier.group_challenge_final_position(song_score, 2).deliver }

    it "sends group challenge final position message to a user" do
      mail.subject.should eq("Group challenge final positions")
      mail.to.should eq([song_score.user.email])
      mail.from.should eq(["no-reply@instrumentchamp.com"])
    end

    it "renders the body" do
      mail.body.encoded.should have_content "Hi #{song_score.user.username},"
      mail.body.encoded.should have_content "The group challenge"
      mail.body.encoded.should have_link  song_score.challenge.song.title, group_challenge_url(song_score.challenge.group, song_score.challenge, host: song_score.user.created_by)
      mail.body.encoded.should have_content  "on InstrumentChamp has finished."
      mail.body.encoded.should have_content "You got #{song_score.score} points and finished nr. 2"
      mail.body.encoded.should have_link "See leaderboard", group_challenge_url(song_score.challenge.group, song_score.challenge, host: song_score.user.created_by)
      check_greeting_lines
    end
  end

  describe "send challenge final position email" do
    let(:song_score) { create(:song_score, challenge: create(:challenge)) }
    let(:mail) { EmailNotifier.challenge_final_position(song_score, 2).deliver }

    it "sends challenge final position message to a user" do
      mail.subject.should eq("Challenge final positions")
      mail.to.should eq([song_score.user.email])
      mail.from.should eq(["no-reply@instrumentchamp.com"])
    end

    it "renders the body" do
      mail.body.encoded.should have_content "Hi #{song_score.user.username},"
      mail.body.encoded.should have_content "The challenge"
      mail.body.encoded.should have_link song_score.challenge.song.title, challenge_url(song_score.challenge, host: song_score.user.created_by)
      mail.body.encoded.should have_content  "on InstrumentChamp has finished."
      mail.body.encoded.should have_content "You got #{song_score.score} points and finished nr. 2"
      mail.body.encoded.should have_link "See leaderboard", challenge_url(song_score.challenge, host: song_score.user.created_by)
      check_greeting_lines
    end
  end

  describe "send friend group invitation via email" do
    let(:user) { create(:user) }
    let(:group) { create(:group) }
    let(:mail) { EmailNotifier.group_invitation_via_email(user, group, "test@user.com").deliver }

    it "sends group invitation via email to a friend" do
      mail.subject.should eq("You were invited to join a group on InstrumentChamp")
      mail.to.should eq(["test@user.com"])
      mail.from.should eq(["no-reply@instrumentchamp.com"])
    end

    it "renders the body" do
      mail.body.encoded.should have_content "Hi,"
      mail.body.encoded.should have_link user.username, person_url(user.username, host: user.created_by)
      mail.body.encoded.should have_content "invited you to join the"
      mail.body.encoded.should have_link group.name, group_url(group, host: user.created_by)
      mail.body.encoded.should have_content "group on InstrumentChamp"
      mail.body.encoded.should have_link "View group", group_url(group, host: user.created_by)
      check_greeting_lines
    end
  end

  def check_greeting_lines
    mail.body.encoded.should have_content "Kind regards,"
    mail.body.encoded.should have_content "The instrumentchamp team."
  end

end
