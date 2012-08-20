class SearchController < ApplicationController
  # GET /search
  # GET /search.json
  def index
    @query = params[:q]
    @what = params[:w]
    
    lastfm = Lastfm.new('930976e93a9a305ccd319242e2a90e58', 'fa79a2ce3ac9477157b158fd08bf06f4')
    
    @results = lastfm.artist.search(@query)
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @results }
    end
  end
end
