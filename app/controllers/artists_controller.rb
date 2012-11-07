class ArtistsController < ApplicationController
  # GET /artists
  # GET /artists.json
  def index
    redirect_to root_path
  end

  # GET /artists/1
  # GET /artists/1.json
  def show
    @query = params[:id].gsub('+', ' ')
    @autoplay = params[:autoplay]
    
    begin
      @artist = LastfmArtist.new(@query, @lastfm)
    rescue
      @artist = nil
    end
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @artist }
    end
  end
end
