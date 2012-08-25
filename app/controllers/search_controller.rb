class SearchController < ApplicationController
  # GET /search
  # GET /search.json
  def index    
    @query = params[:q]
    @what = params[:w]
    
    artist = Artist.new(@query, @lastfm)
    
    @results = artist.find()
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @results }
    end
  end
end
