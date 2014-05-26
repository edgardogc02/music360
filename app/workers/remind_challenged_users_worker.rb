class RemindChallengedUsersWorker
  include Sidekiq::Worker

  def perform
    challenges = Challenge.challenged_users_to_remind
    challenges.each do |challenge|
      if challenge.challenged.can_receive_messages?
        EmailNotifier.remind_challenged_user(challenge).deliver
      end
    end
  end
end