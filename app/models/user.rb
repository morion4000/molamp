class User < ActiveRecord::Base
  after_create :deliver_signup_notification
  acts_as_authentic
  
  attr_accessible :email, :password, :password_confirmation
  
  def deliver_signup_notification
    UserMailer.signup_notification(self)
  end
end