class MandrillTemplateEmailNotifier < MandrillMailer::TemplateMailer

  default from: "no-reply@instrumentchamp.com"

  def test_mandrill_template(user)
    mandrill_mail template: 'test',
                  subject: 'Mandrill template email test!',
                  to: {email: "edgardo.cabanillas@instrumentchamp.com", name: "Edgardo"}
  end

end
