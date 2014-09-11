class MandrillTemplateEmailNotifier < MandrillMailer::TemplateMailer

  default from: "no-reply@instrumentchamp.com", from_name: "InstrumentChamp"

  def test_mandrill_template(user)
    mandrill_mail template: 'test',
                  subject: 'Mandrill template email test!',
                  to: {email: "edgardo.cabanillas@instrumentchamp.com", name: "Edgardo"}
  end

  def welcome_email_mandrill_template(user)
    mandrill_mail template: 'welcome-to-instrumentchamp-be-a-music-player',
                  subject: 'Welcome to InstrumentChamp',
                  to: {email: "edgardo.cabanillas@instrumentchamp.com", name: "Edgardo"},
                  vars: { 'USERNAME' => user.username }
  end

end
