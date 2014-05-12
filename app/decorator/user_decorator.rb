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

end