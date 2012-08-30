  class SearchController < ApplicationController
  # GET /search
  # GET /search.json
  def index
    # TODO: Need to redirect if the params are not set
    # BUG: If the artist name contains special characters, the application crashes
    @query = params[:q]
    @where = params[:w]
    
    if @where == 'home'
      redirect_to '/artists/' + @query.gsub(' ', '+')
    else
      artist = Artist.new(@query, @lastfm)
      album = Album.new(@query, @lastfm)
      
      @artists = artist.find()
      @albums = album.find()
      
      respond_to do |format|
        format.html # index.html.erb
        format.json { render :json => @artists }
      end
    end
  end
end
