class TracksController < ApplicationController
  def show
    artist = params[:artist].gsub('+', ' ')
    track = params[:track].gsub('+', ' ')
    @autoplay = params[:autoplay]
    
    begin
      track = Track.new(track, artist, @lastfm)
      @track = track.info
    rescue
      @track = nil
    end
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @track }
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
