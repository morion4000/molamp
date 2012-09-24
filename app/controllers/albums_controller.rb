class AlbumsController < ApplicationController
  def show
    artist = params[:artist].gsub('+', ' ')
    album = params[:album].gsub('+', ' ')
    @autoplay = params[:autoplay]
    
    album = Album.new(album, artist, @lastfm)
    @album = album.info
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @album }
    end
  end
end
