class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :set_lastfm, :authenticate

  Rails.env.production? do
    before_filter :check_url
  end

  def check_url
    redirect_to request.protocol + "www." + request.host_with_port + request.fullpath if !/^www/.match(request.host)
  end
  
  def set_lastfm
    @lastfm = Lastfm.new(APP_CONFIG['lastfm_api_key'], APP_CONFIG['lastfm_api_secret'])
    
    if cookies[:lastfm_session]
      @lastfm.session = cookies.signed[:lastfm_session]
    end
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
