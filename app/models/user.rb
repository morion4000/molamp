class User < ActiveRecord::Base
  after_create :deliver_signup_notification
  acts_as_authentic
  
  attr_accessible :email, 
                  :password, 
                  :password_confirmation, 
                  :facebook_token,
                  :facebook_username,
                  :facebook_image, 
                  :manual, 
                  :claimed
  
  def deliver_signup_notification
    #UserMailer.signup_notification(self).deliver
  end
end