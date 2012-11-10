class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :check_url, :set_lastfm, :set_facebook, :authenticate, :check_facebook_referral
  
  helper :all
  helper_method :current_user_session, :current_user
  
  private
    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end
    
    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.record
    end
    
    def require_user
      unless current_user
        store_location
        flash[:notice] = "You must be logged in to access this page"
        redirect_to new_user_session_url
        return false
      end
    end

    def require_no_user
      if current_user
        store_location
        flash[:notice] = "You must be logged out to access this page"
        redirect_to account_url
        return false
      end
    end
    
    def store_location
      session[:return_to] = request.request_uri
    end
    
    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end
    
    def logged_in?
      current_user && !current_user_session.stale?
    end
  
  protected
  
  def authenticate
    if APP_CONFIG['perform_authentication']
      authenticate_or_request_with_http_basic do |username, password|
        username == APP_CONFIG['username'] && password == APP_CONFIG['password']
      end
    end
  end
  
  def check_url
    redirect_to request.protocol + "www." + request.host_with_port + request.fullpath, :status => 301 if /^molamp.net/.match(request.host) if !/^www/.match(request.host) if Rails.env.production? 
  end
  
  def set_lastfm
    @lastfm = Lastfm.new(APP_CONFIG['lastfm_api_key'], APP_CONFIG['lastfm_api_secret'])
    
    if logged_in? and current_user.lastfm_token
      @lastfm.session = current_user.lastfm_token
    end
  end
  
  def set_facebook
    if logged_in? and current_user.facebook_token
      @facebook = Koala::Facebook::API.new(current_user.facebook_token)
    end
  end
  
  def check_facebook_referral
    code = params[:code]
    redirect_uri = params[:redirect_uri]
    return_to = params[:return_to]
    
    if !code.to_s.blank? and return_to.to_s.blank? 
      # Auth referral
      redirect_to '/auth/facebook?return_to=' +
                   redirect_uri + 
                   #request.protocol + request.host_with_port + request.path +
                  '&code='+code
    end
  end
end
