class SearchController < ApplicationController
  # GET /search
  # GET /search.json
  def index
    # TODO: Need to redirect if the params are not set
    @query = params[:q]
    # BUG: If the artist name contains special characters, the application crashes
    @what = params[:w]
    
    artist = Artist.new(@query, @lastfm)
    
    @results = artist.find()
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @results }
    end
  end
end
