class ArtistsController < ApplicationController
  # GET /artists
  # GET /artists.json
  def index
    @artist = nil
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @artist }
    end
  end

  # GET /artists/1
  # GET /artists/1.json
  def show
    @query = params[:id]
        
    @artist = @lastfm.artist.get_info(@query) 
    @top_tracks = @lastfm.artist.get_top_tracks(@query)
     
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @artist }
    end
  end
end
