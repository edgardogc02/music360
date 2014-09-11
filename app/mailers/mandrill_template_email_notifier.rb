class MandrillTemplateEmailNotifier < MandrillMailer::TemplateMailer

  default from: "no-reply@instrumentchamp.com", from_name: "InstrumentChamp"

  def welcome_email_mandrill_template(user)
    mandrill_mail template: 'welcome-to-instrumentchamp-be-a-music-player',
                  subject: 'Welcome to InstrumentChamp',
                  to: {email: user.email, name: user.username},
                  vars: { 'USERNAME' => user.username }
  end

  def welcome_email_mandrill_template(user_purchased_song, payment)
    mandrill_mail template: 'instrumentchamp-support-receipt-premium-songs',
                  subject: 'Your purchase on InstrumentChamp',
                  to: {email: user_purchased_song.user.email, name: user_purchased_song.user.username},
                  vars: { 'USERNAME' => user.username,
                          'SONGNAME' => user_purchased_song.song.title,
                          'SONG_URL' => song_url(user_purchased_song.song),
                          'ARTISTNAME' => user_purchased_song.song.artist.title,
                          'WRITTENBY' => user_purchased_song.song.writer,
                          'PUBLISHER' => user_purchased_song.song.publisher,
                          'PAYMENTAMOUNT' => payment.amount,
                          'PAYMENTMETHOD' => payment.payment_method.name
                         }
  end

end
