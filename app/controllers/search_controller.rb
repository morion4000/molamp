  class SearchController < ApplicationController
  # GET /search
  # GET /search.json
  def index
    # TODO: Need to redirect if the params are not set
    # BUG: If the artist name contains special characters, the application crashes
    @query = params[:q]
    @where = params[:w]
    
    artist = Artist.new(@query, @lastfm)
    #album = Album.new(@query, nil, @lastfm)
    
    @artists = artist.find()
    #@albums = album.find()
    
    if @where == 'home' and !@artists['results']['artistmatches']['artist'].nil?
      first_artist = @artists['results']['artistmatches']['artist'][0]
      redirect_to '/artists/' + first_artist['name'].gsub(' ', '+')
    else
      respond_to do |format|
        format.html # index.html.erb
        format.json { render :json => @artists }
      end
    end
  end
end
