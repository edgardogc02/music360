class EmailNotifier < ActionMailer::Base

  default from: "InstrumentChamp <no-reply@instrumentchamp.com>"

  def welcome_message(user)
    @user = user
    @host = "https://www.instrumentchamp.com"
    mail to: @user.email
  end

end
