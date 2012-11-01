class AjaxController < ApplicationController
  def scrobble
    artist = params[:artist]
    track = params[:track]
    result = {:result => 'failed'}
    
    if current_user.lastfm_token and current_user.scrobble_mode === true and Rails.env.production?
      tracks = Track.new(track, artist, @lastfm)
      
      if tracks.scrobble
        result = {:result => 'successfull'}
      end
    end
    
    respond_to do |format|
      format.html { render :json => result }
    end
  end
  
  def activity
    artist = params[:artist]
    track = params[:track]
    
    song_url = 'http://www.molamp.net/artists/' + artist.gsub(' ', '+') + '/_/' + track.gsub(' ', '+')
    
    if current_user.facebook_token and current_user.activity_mode === true and Rails.env.production?
      @facebook.put_connections('me', 'music.listens', :song => URI.escape(song_url))
    end
    
    respond_to do |format|
      format.html { render :json => true }
    end
  end
  
  def scrobble_mode
    mode = params[:mode]
    
    if mode == 'on'
      current_user.scrobble_mode = true
    else
      current_user.scrobble_mode = false
    end
    
    current_user.save
    
    respond_to do |format|
      format.html { render :json => true }
    end
  end
  
  def activity_mode
    mode = params[:mode]
    
    if mode == 'on'
      current_user.activity_mode = true
    else
      current_user.activity_mode = false
    end
    
    current_user.save
    
    respond_to do |format|
      format.html { render :json => true }
    end
  end
end
