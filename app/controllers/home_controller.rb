class HomeController < ApplicationController
  def index
    code = params[:code]
    
    if !code.to_s.blank?
      # Auth referral
      redirect_to '/auth/facebook?code='+code
    end
    
    if current_user.respond_to?('lastfm_token') and current_user.lastfm_token
      begin
        @query = current_user.lastfm_username
        
        user = LastfmUser.new(@query, @lastfm)
        
        @top_artists = user.top_artists
      rescue
        @top_artists  = nil
      end
    end
    
    if current_user.respond_to?('facebook_token') and current_user.facebook_token
      begin
        @likes = @facebook.get_connections('me', 'likes')
      rescue
        @likes = nil
      end
    end
  end
end
