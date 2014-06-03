class UserDecorator < Draper::Decorator

  delegate_all

  def self.collection_decorator_class
    PaginatingDecorator
  end

  def display_follow_button?
    false
  end

  def display_follow_button
    if display_follow_button?
      if h.current_user.following?(user)
        h.render 'users/unfollow', user: model
      else
        h.render 'users/follow', user: model
      end
    end
  end
  
  def challenge_button(song_id="")
    h.action_button(h.new_challenge_path(song_id: song_id, challenged_id: user.id), 'Challenge', {class: 'Activation2 Activation2_Challenge Activation2_Challenge_Users', id: "challenge_#{user.id}"})
  end

end