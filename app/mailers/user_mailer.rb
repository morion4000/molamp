class UserMailer < ActionMailer::Base
  default :from => 'notifications@molamp.net'
  
  def signup_notification(user)
    @user = user
    @url  = 'http://www.molamp.com/login'
    mail(:to => 'morion4000@gmail.com', :subject => 'Welcome')
  end
end
