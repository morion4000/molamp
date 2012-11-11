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
    scope = 'user_likes,publish_actions,email'
    
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
    
    if session[:facebook_state] and session[:facebook_state] === params[:state]
      unless logged_in?
        facebook_token = self.get_fb_access_token code, APP_CONFIG['facebook_redirect_url'].to_s
        
        if facebook_token.has_key?('access_token')
          access_token = facebook_token['access_token']
          
          facebook = Koala::Facebook::API.new(access_token)
          
          profile = facebook.get_object('me', {:fields => 'email'})
          
          #profile['email'] = 'testsssss@tessss.com'
          
          user = User.find_or_create_by_email(
            :email => profile['email'],
            :facebook_token => access_token, 
            :password => Digest::MD5.hexdigest(rand(999999).to_s + access_token),
            :manual => false
           )
                    
          unless user.facebook_token
            user.facebook_token = access_token
          end
          
          user.save
          
          UserSession.create(user, true) # skip authentication and log the user in directly, the true means "remember me"
  
          redirect_to session[:fb_return_to], :notice => 'You have successfully been logged in with your Facebook account.' and return
        end
      else
          facebook_token = self.get_fb_access_token code, APP_CONFIG['facebook_redirect_url'].to_s
          
          if facebook_token.has_key?('access_token')
            current_user.facebook_token = facebook_token['access_token']
            current_user.save
            
            redirect_to '/account/social', :notice => 'You have successfully been connected with your Facebook account.' and return
          end
      end
    else
      render :text => 'Error. The state session does not match. Please try again later.' and return
    end
    
    redirect_to '/', :notice => 'There was an error with your Facebook access token.' and return
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
      
      return parameters
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
