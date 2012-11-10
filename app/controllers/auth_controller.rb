class AuthController < ApplicationController  
  def lastfm
    token = params[:token]
    
    if token.to_s.blank?
      redirect_to 'http://www.last.fm/api/auth/?api_key=' + APP_CONFIG['lastfm_api_key'].to_s
    else
      session = @lastfm.auth.get_session(:token => token)
      
      current_user.lastfm_token = session['key']
      current_user.lastfm_username = session['name']
      current_user.save
      
      redirect_to '/account/social', :notice => 'You have successfully been connected with your Last.fm account.'
    end
  end
  
  def facebook
    code = params[:code]
    referral = params[:referral]
    scope = 'user_likes,publish_actions'
        
    if code.to_s.blank?
      session[:facebook_state] = Digest::MD5.hexdigest(rand(1000).to_s);
      
      redirect_to 'https://www.facebook.com/dialog/oauth?client_id=' +
                  APP_CONFIG['facebook_api_key'].to_s + 
                  '&redirect_uri=' +
                  APP_CONFIG['facebook_redirect_url'].to_s +
                  '&state=' + 
                  session[:facebook_state] +
                  '&scope=' + scope and return
    end
    
    unless logged_in?
      # Auth referral
      redirect_url = params[:return_to]
      facebook_token = self.get_fb_access_token code, CGI::escape(redirect_url)
      
      user = User.new(:facebook_token => facebook_token)
    
      redirect_to redirect_url, :notice => "fb: #{facebook_token}" and return
    else
      #if session[:facebook_state] and session[:facebook_state] === params[:state]
      facebook_token = self.get_fb_access_token code, APP_CONFIG['facebook_redirect_url'].to_s
      
      current_user.facebook_token = facebook_token
      current_user.save
      
      redirect_to '/account/social', :notice => 'You have successfully been connected with your Facebook account.' and return
      #else  
      #  render :text => 'Error. The state does not match.' and return
      #end
    end
  end
  
  def get_fb_access_token(code, redirect_url)
    fb_access_token_url = URI.parse(
                              'https://graph.facebook.com/oauth/access_token?client_id=' +
                              APP_CONFIG['facebook_api_key'].to_s +
                              '&redirect_uri=' + redirect_url +
                              '&client_secret=' + APP_CONFIG['facebook_api_secret'].to_s +
                              '&code=' + code
                            )
        
      https = Net::HTTP.new(fb_access_token_url.host, fb_access_token_url.port)    
      https.use_ssl = true                                                         
      https.verify_mode = OpenSSL::SSL::VERIFY_NONE
    
      response = https.request_get(fb_access_token_url.path + '?' + fb_access_token_url.query)
      
      parameters = Rack::Utils.parse_nested_query(response.body)
      
      return parameters['access_token']
  end
  
  def logout_lastfm
    current_user.lastfm_token = nil
    current_user.lastfm_username = nil
    current_user.scrobble_mode = true
    current_user.save
        
    redirect_to '/account/social', :notice => 'You have successfully been disconnected from your Last.fm account.'
  end
  
  def logout_facebook
    current_user.facebook_token = nil
    current_user.activity_mode = true
    current_user.save
    
    redirect_to '/account/social', :notice => 'You have successfully been disconnected from your Facebook account.'
  end
end
