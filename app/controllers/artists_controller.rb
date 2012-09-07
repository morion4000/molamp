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
    @autoplay = params[:autoplay]
    
    begin
      artist = Artist.new(@query, @lastfm)
      
      @top_tracks = artist.top_tracks
      @top_albums = artist.top_albums
      @artist = artist.info
    rescue
      @top_tracks  = nil
      @top_albums  = nil
      @artist = nil
    end
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @top_tracks }
    end
  end
end
