class MandrillTemplateEmailNotifier < MandrillMailer::TemplateMailer

  default from: "InstrumentChamp <no-reply@instrumentchamp.com>"

  def test(user)
    mandrill_mail template: 'Test',
                  subject: 'Mandrill template email test!',
                  to: {email: "edgardo.cabanillas@instrumentchamp.com", name: user.username}
  end

end
