class AuthController < ApplicationController
  def lastfm
    token = params[:token]
    
    session = @lastfm.auth.get_session(:token => token)
    
    cookies.permanent.signed[:lastfm_session] = session['key']
    cookies.permanent.signed[:lastfm_user] = session['name']
    
    redirect_to '/'
  end
  
  def logout
    if cookies[:lastfm_session]
      cookies.delete :lastfm_session
      cookies.delete :lastfm_user
    end
    
    redirect_to '/'
  end
end
