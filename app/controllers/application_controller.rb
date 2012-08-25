class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :set_lastfm, :authenticate
  def set_lastfm
    @lastfm = Lastfm.new(APP_CONFIG['lastfm_api_key'], APP_CONFIG['lastfm_api_secret'])
  end
  
  protected
  
  def authenticate
    if APP_CONFIG['perform_authentication']
      authenticate_or_request_with_http_basic do |username, password|
        username == APP_CONFIG['username'] && password == APP_CONFIG['password']
      end
    end
  end
end
