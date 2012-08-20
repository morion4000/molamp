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
    
    lastfm = Lastfm.new('930976e93a9a305ccd319242e2a90e58', 'fa79a2ce3ac9477157b158fd08bf06f4')
    
    @artist = lastfm.artist.get_info(@query) 
    @top_tracks = lastfm.artist.get_top_tracks(@query)
     
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @artist }
    end
  end
end
