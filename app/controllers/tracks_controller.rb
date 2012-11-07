class TracksController < ApplicationController
  def show
    artist = params[:artist].gsub('+', ' ')
    track = params[:track].gsub('+', ' ')
    @autoplay = params[:autoplay]
    
    begin
      @track = LastfmTrack.new(track, artist, @lastfm)
    rescue
      @track = nil
    end
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @track }
    end    
  end
end
