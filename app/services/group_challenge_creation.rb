class GroupChallengeCreation

  attr_accessor :challenge

  def initialize(challenge)
    @challenge = challenge
  end

  def save
    if challenge.save
      if challenge.start_at <= Time.now
        save_activity
        notify_users
      end
      true
    else
      false
    end
  end

  private

  def save_activity
    @challenge.create_activity :group_challenge_create, owner: @challenge.challenger, group_id: @challenge.group.id, challenge_id: @challenge.id
  end

  def notify_users
    @challenge.group.users.each do |user|
      MandrillTemplateEmailNotifier.group_challenge_created_mandrill_template(@challenge, user).deliver
#      EmailNotifier.group_challenge_created(@challenge, user).deliver
    end
  end

end