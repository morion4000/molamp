class UserMailer < ActionMailer::Base
  default :from => 'notifications@molamp.net'
  
  def signup_notification(user)
    @user = user
    @url  = 'http://www.molamp.net/login'
    mail(:to => user.email, :subject => 'Welcome')
  end
end
