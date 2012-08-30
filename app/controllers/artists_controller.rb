class ArtistsController < ApplicationController
  # GET /artists
  # GET /artists.json
  def index
    redirect_to '/'
  end

  # GET /artists/1
  # GET /artists/1.json
  def show
    @query = params[:id].gsub('+', ' ')
    
    begin
      artist = Artist.new(@query, @lastfm)
      
      @top_tracks = artist.top_tracks
      @artist = artist.info
    rescue
      @top_tracks = nil
      @artist = nil
    end
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @artist }
    end
  end
end
