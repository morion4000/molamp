class SearchController < ApplicationController
  # GET /search
  # GET /search.json
  def index
    @query = params[:q]
    
    lastfm = Lastfm.new('f21088bf9097b49ad4e7f487abab981e', '7ccaec2093e33cded282ec7bc81c6fca')
    
    @results = lastfm.artist.search(@query)
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @results }
    end
  end
end
