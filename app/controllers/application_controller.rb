class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :check_url, :set_lastfm, :set_facebook, :authenticate, :check_facebook_referral
  
  helper :all
  helper_method :current_user_session, :current_user
  
  unless Rails.application.config.consider_all_requests_local
    rescue_from Exception, :with => lambda { |exception| render_error 500, exception }
    rescue_from ActionController::RoutingError, ActionController::UnknownController, ::AbstractController::ActionNotFound, ActiveRecord::RecordNotFound, :with => lambda { |exception| render_error 404, exception }
  end
  
  private
    def render_error(status, exception)
      respond_to do |format|
        format.html { render :template => "errors/error_#{status}", :layout => 'layouts/application', :status => status }
        format.all { render :nothing => true, :status => status }
      end
    end
    
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
        flash[:notice] = 'You must be logged in to access this page'
        redirect_to new_user_session_url
        return false
      end
    end

    def require_no_user
      if current_user
        store_location
        flash[:notice] = 'You must be logged out to access this page'
        redirect_to account_url
        return false
      end
    end
    
    def store_location
      session[:return_to] = request.url
    end
    
    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end
    
    def logged_in?
      current_user && !current_user_session.stale?
    end
    
    def not_found
      raise ActionController::RoutingError.new('Not Found')
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
    @lastfm = Lastfm.new(ENV['LASTFM_API_KEY'], ENV['LASTFM_API_SECRET'])
    
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
    controller = params[:controller]
    
    if !code.to_s.blank? and controller != 'auth'
      query = Rack::Utils.parse_nested_query(request.query_string)
      query.delete('code')
      query_string = Rack::Utils.build_query(query)
                 
      redirect_url = request.protocol + request.host_with_port + request.path + '?' + query_string
      
      unless logged_in?
        redirect_to '/auth/facebook', :notice => redirect_url and return
        #redirect_to redirect_url, :notice => 'You can <a href="/auth/facebook">login with your Facebook account</a> to retreive your favorite artists and post on your Timeline.'.html_safe and return
      else
        if not current_user.facebook_token
          redirect_to '/auth/facebook', :notice => redirect_url and return
          #redirect_to redirect_url, :notice => 'You can <a href="/auth/facebook">connect with your Facebook account</a> to retreive your favorite artists and post on your Timeline.'.html_safe and return
        else
          redirect_to redirect_url, :notice => 'Welcome back from Facebook.' and return
        end
      end
    end
  end
end
