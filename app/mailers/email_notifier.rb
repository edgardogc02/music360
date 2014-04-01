class EmailNotifier < ActionMailer::Base

  default from: "from@example.com"

  def send_user_confirmation(user)
    @user = user
    mail to: @user.email
  end

end
