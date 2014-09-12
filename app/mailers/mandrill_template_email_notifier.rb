class MandrillTemplateEmailNotifier < MandrillMailer::TemplateMailer

  default from: "no-reply@instrumentchamp.com", from_name: "InstrumentChamp"

  def welcome_email_mandrill_template(user)
    mandrill_mail template: 'welcome-to-instrumentchamp-be-a-music-player',
                  subject: 'Welcome to InstrumentChamp - Be a music player',
                  to: {email: user.email, name: user.username},
                  vars: { 'USERNAME' => user.username }
  end

  def purchased_song_mandrill_template(user_purchased_song, payment)
    mandrill_mail template: 'instrumentchamp-support-receipt-premium-songs',
                  subject: 'Your purchase on InstrumentChamp',
                  to: {email: user_purchased_song.user.email, name: user_purchased_song.user.username},
                  vars: { 'USERNAME' => user_purchased_song.user.username,
                          'SONGNAME' => user_purchased_song.song.title,
                          'SONGURL' => artist_song_url(user_purchased_song.song.artist, user_purchased_song.song),
                          'ARTISTNAME' => user_purchased_song.song.artist.title,
                          'WRITTENBY' => user_purchased_song.song.writer,
                          'PUBLISHER' => user_purchased_song.song.publisher,
                          'PAYMENTAMOUNT' => payment.currency + ' ' + payment.amount.to_s,
                          'PAYMENTMETHOD' => payment.payment_method.name
                         }
  end

  def user_premium_subscription_mandrill_template(user_premium_subscription)
    mandrill_mail template: 'instrumentchamp-support-receipt-premium-members',
                  subject: 'InstrumentChamp Support: Receipt - Premium Members',
                  to: {email: user_premium_subscription.user.email, name: user_premium_subscription.user.username},
                  vars: { 'USERNAME' => user_premium_subscription.user.username,
                          'SUBSCRIPTIONMEMBERSHIP' => user_premium_subscription.premium_plan.name,
                          'PAYMENTAMOUNT' => user_premium_subscription.payment.currency + ' ' + user_premium_subscription.payment.amount.to_s,
                          'PAYMENTMETHOD' => user_premium_subscription.payment.payment_method.name
                         }
  end

  def challenged_user_mandrill_template(challenge)
    mandrill_mail template: 'challenger-has-challenged-you',
                  subject: 'You have a new challenge on InstrumentChamp',
                  to: {email: challenge.challenged.email, name: challenge.challenged.username},
                  vars: { 'USERNAME' => challenge.challenger.username,
                          'CHALLENGEURL' => challenge_url(challenge)
                         }
  end

  def remind_challenged_user_mandrill_template(challenge)
    mandrill_mail template: 'challenger-is-waiting-for-you-to-accept-the-challe',
                  subject: 'Challenge reminder on InstrumentChamp',
                  to: {email: challenge.challenged.email, name: challenge.challenged.username},
                  vars: { 'USERNAME' => challenge.challenger.username,
                          'CHALLENGEURL' => challenge_url(challenge)
                         }
  end

  def remind_challenger_user_mandrill_template(challenge)
    mandrill_mail template: 'challenger-has-pending-challenge',
                  subject: 'Challenge reminder on InstrumentChamp',
                  to: {email: challenge.challenger.email, name: challenge.challenger.username},
                  vars: { 'USERNAME' => challenge.challenged.username,
                          'CHALLENGEURL' => challenge_url(challenge)
                         }
  end

  def group_challenge_created_mandrill_template(challenge, user)
    mandrill_mail template: 'groupname-has-challenged-you',
                  subject: 'New group challenge created',
                  to: {email: user.email, name: user.username},
                  vars: { 'GROUPNAME' => challenge.group.name,
                          'CHALLENGEURL' => group_challenge_url(challenge.group, challenge)
                         }
  end

  def remind_user_to_install_the_game_mandrill_template(user)
    mandrill_mail template: 'instrumentchamp-support-do-you-need-any-help-1',
                  subject: 'Do you need some help?',
                  to: {email: user.email, name: user.username},
                  vars: { 'USERNAME' => user.username }
  end

  def remind_user_to_play_songs_mandrill_template(user)
    mandrill_mail template: 'instrumentchamp-support-do-you-need-any-help-2',
                  subject: 'Do you need some help?',
                  to: {email: user.email, name: user.username},
                  vars: { 'USERNAME' => user.username }
  end

  def improve_music_career_mandrill_template(user)
    mandrill_mail template: 'improve-your-music-career-retry',
                  subject: 'Improve your music career',
                  to: {email: user.email, name: user.username},
                  vars: { 'USERNAME' => user.username }
  end

end
