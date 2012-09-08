class AuthController < ApplicationController
  def lastfm
    token = params[:token]
    
    cookies.permanent.signed[:lastfm_auth] = token
    
    redirect_to '/'
  end
end
