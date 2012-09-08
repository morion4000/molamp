class TracksController < ApplicationController
  def show    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => nil }
    end
  end
  
  def scrobble
    artist = params[:artist]
    track = params[:track]
    result = {:result => 'failed'}
    
    if cookies[:lastfm_session] and Rails.env.production?
      tracks = Track.new(track, artist, @lastfm)
      
      if tracks.scrobble
        result = {:result => 'successfull'}
      end
    end
    
    respond_to do |format|
      format.html { render :json => result }
    end
  end
end
