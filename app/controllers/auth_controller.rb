class AuthController < ApplicationController
  @@facebook_redirect_url = 'http://www.molamp.net/auth/facebook'
  
  def self.facebook_redirect_url
    @@facebook_redirect_url
  end
  
  def lastfm
    token = params[:token]
    
    if token.to_s.blank?
      redirect_to 'http://www.last.fm/api/auth/?api_key=' + APP_CONFIG['lastfm_api_key'].to_s
    else
      session = @lastfm.auth.get_session(:token => token)
      
      current_user.lastfm_token = session['key']
      current_user.lastfm_username = session['name']
      current_user.save
      
      redirect_to '/account', :notice => 'You have successfully been connected with your Last.fm account.'
    end
  end
  
  def facebook
    code = params[:code]
    scope = 'user_likes,publish_actions'
        
    if code.to_s.blank?
      session[:facebook_state] = Digest::MD5.hexdigest(rand(1000).to_s);
      
      redirect_to 'https://www.facebook.com/dialog/oauth?client_id=' +
                  APP_CONFIG['facebook_api_key'].to_s + 
                  '&redirect_uri=' +
                  @@facebook_redirect_url +
                  '&state=' + 
                  session[:facebook_state] +
                  '&scope=' + scope
    end
    
    if session[:facebook_state] and session[:facebook_state] === params[:state]
      
            
      current_user.facebook_token = self.get_fb_access_token code
      current_user.save
      
      redirect_to '/account', :notice => 'You have successfully been connected with your Facebook account.'   
    else  
      # state is does not match
    end
  end
  
  def get_fb_access_token(code)
    fb_access_token_url = URI.parse(
                              'https://graph.facebook.com/oauth/access_token?client_id=' +
                              APP_CONFIG['facebook_api_key'].to_s +
                              '&redirect_uri=' + @@facebook_redirect_url +
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
        
    redirect_to '/account', :notice => 'You have successfully been disconnected from your Last.fm account.'
  end
  
  def logout_facebook
    current_user.facebook_token = nil
    current_user.activity_mode = true
    current_user.save
    
    redirect_to '/account', :notice => 'You have successfully been disconnected from your Facebook account.'
  end
end
