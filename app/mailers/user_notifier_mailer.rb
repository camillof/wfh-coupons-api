class UserNotifierMailer < ApplicationMailer
    default from: 'kreitech.test@gmail.com'
    # send a signup email to the user, pass in the user object that   contains the user's email address
  def alert_email(user)
    @user = user
    mail( :to => 'amalaquina@kreitech.io',
    :subject => 'You have a request from: '+ @user.email  )
  end

  def alert_email_response(user, body)
    @user = user
    @body = body
    mail( :to => user.email,
    :subject => 'Answer your request  ')
  end
end
