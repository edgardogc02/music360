class MandrillTemplateEmailNotifier < MandrillMailer::TemplateMailer

  default from: "InstrumentChamp <no-reply@instrumentchamp.com>"

  def test(user)
    mandrill_mail template: 'Test',
                  subject: 'Mandrill template email test!',
                  to: {email: user.email, name: user.username}
  end

end
