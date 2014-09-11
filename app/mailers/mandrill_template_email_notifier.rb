class MandrillTemplateEmailNotifier < MandrillMailer::TemplateMailer

  default from: "no-reply@instrumentchamp.com", from_name: "InstrumentChamp"

  def welcome_email_mandrill_template(user)
    mandrill_mail template: 'welcome-to-instrumentchamp-be-a-music-player',
                  subject: 'Welcome to InstrumentChamp',
                  to: {email: user.email, name: user.username},
                  vars: { 'USERNAME' => user.username }
  end

  def purchased_song_mandrill_template(user_purchased_song, payment)
    mandrill_mail template: 'instrumentchamp-support-receipt-premium-songs',
                  subject: 'Your purchase on InstrumentChamp',
                  to: {email: user_purchased_song.user.email, name: user_purchased_song.user.username},
                  vars: { 'USERNAME' => user_purchased_song.user.username,
                          'SONGNAME' => user_purchased_song.song.title,
                          'SONGURL' => artist_song_url(user_purchased_song.song.artist, user_purchased_song.song, host: user_purchased_song.user.created_by),
                          'ARTISTNAME' => user_purchased_song.song.artist.title,
                          'WRITTENBY' => user_purchased_song.song.writer,
                          'PUBLISHER' => user_purchased_song.song.publisher,
                          'PAYMENTAMOUNT' => payment.currency + ' ' + payment.amount.to_s,
                          'PAYMENTMETHOD' => payment.payment_method.name
                         }
  end

end
