class RemindChallengerUsersWorker
  include Sidekiq::Worker

  def perform
    challenges = Challenge.challenger_users_to_remind
    challenges.each do |challenge|
      if challenge.challenger.can_receive_messages?
        MandrillTemplateEmailNotifier.remind_challenger_user_mandrill_template(challenge).deliver
#        EmailNotifier.remind_challenger_user(challenge).deliver
      end
    end
  end
end