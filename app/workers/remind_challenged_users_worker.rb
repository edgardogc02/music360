class RemindChallengedUsersWorker
  include Sidekiq::Worker

  def perform
    challenges = Challenge.challenged_users_to_remind
    challenges.each do |challenge|
      if challenge.challenged.can_receive_messages?
        MandrillTemplateEmailNotifier.remind_challenged_user_mandrill_template(challenge).deliver
#        EmailNotifier.remind_challenged_user(challenge).deliver
      end
    end
  end
end