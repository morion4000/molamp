class AuthController < ApplicationController
  def lastfm
    token = params[:token]
    
    if token.to_s.blank?
      redirect_to 'http://www.last.fm/api/auth/?api_key=' + APP_CONFIG['lastfm_api_key'].to_s
    else
      session = @lastfm.auth.get_session(:token => token)
      
      cookies.permanent.signed[:lastfm_session] = session['key']
      cookies.permanent.signed[:lastfm_user] = session['name']
      
      redirect_to '/account', :notice => 'You have successfully been connected with your Last.fm account.'
    end
  end
  
  def facebook
    code = params[:code]
    redirect_url = 'http://www.molamp.net/auth/facebook'
    scope = 'user_about_me,user_likes,friends_likes,publish_actions,user_actions.music,friends_actions.music'
        
    if code.to_s.blank?
      session[:facebook_state] = Digest::MD5.hexdigest(rand(1000).to_s);
      
      redirect_to 'https://www.facebook.com/dialog/oauth?client_id=' +
                  APP_CONFIG['facebook_api_key'].to_s + 
                  '&redirect_uri=' +
                  redirect_url +
                  '&state=' + 
                  session[:facebook_state] +
                  '&scope=' + scope
    end
    
    if session[:facebook_state] and session[:facebook_state] === params[:state]
      session_url = 'https://graph.facebook.com/oauth/access_token?client_id=' +
                    APP_CONFIG['facebook_api_key'].to_s +
                    '&redirect_uri=' + redirect_url +
                    '&client_secret=' + APP_CONFIG['facebook_api_secret'].to_s +
                    '&code=' + code
    
      response = Net::HTTP.get_response(URI.parse(session_url)).body
      parameters = Rack::Utils.parse_nested_query(response)
      
      cookies.permanent.signed[:facebook_session] = parameters[:access_token]
      
      redirect_to '/account', :notice => 'You have successfully been connected with your Facebook account.'    
    else
      #die  
    end
  end
  
  def logout
    if cookies[:lastfm_session]
      cookies.delete :lastfm_session
      cookies.delete :lastfm_user
    end
    
    redirect_to '/account', :notice => 'You have successfully been disconnected from your Last.fm account.'
  end
end
