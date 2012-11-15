class User < ActiveRecord::Base
  after_create :deliver_signup_notification
  acts_as_authentic
  
  attr_accessible :email, 
                  :password, 
                  :password_confirmation, 
                  :facebook_token,
                  :facebook_username,
                  :manual, 
                  :claimed,
                  :username
                  
  validates_format_of :username, :with => /([a-zA-Z]0-9)*/
 
  acts_as_authentic do |c| 
    c.login_field = :email 
  end
  
  def deliver_signup_notification
    UserMailer.signup_notification(self).deliver
  end
end