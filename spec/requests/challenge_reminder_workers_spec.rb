require 'spec_helper'

describe "ChallengeReminderWorkers" do

  it "should send a reminder email to challenged users" do
    challenge = create(:challenge)
    challenge_to_remind = create(:challenge, created_at: 25.hours.ago, score_u1: 100)
    RemindChallengedUsersWorker.new.perform
    last_email.to.should include(challenge_to_remind.challenged.email)
  end

  it "should send a reminder email to challenger user" do
    challenge = create(:challenge)
    challenge_to_remind = create(:challenge, created_at: 25.hours.ago)
    RemindChallengerUsersWorker.new.perform
    last_email.to.should include(challenge_to_remind.challenger.email)
  end

end
