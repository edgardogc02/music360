class MandrillTemplateEmailNotifier < MandrillMailer::TemplateMailer

  default from: "InstrumentChamp <no-reply@instrumentchamp.com>"

  def test_mandrill_template(user)
    mandrill_mail template: 'Test',
                  subject: 'Mandrill template email test!',
                  to: "edgardo.cabanillas@instrumentchamp.com"
  end

end
