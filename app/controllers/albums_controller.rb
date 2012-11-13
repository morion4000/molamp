class AlbumsController < ApplicationController
  def show
    artist = params[:artist].gsub('+', ' ')
    album = params[:album].gsub('+', ' ')
    @autoplay = params[:autoplay]
    
    begin
      @album = LastfmAlbum.new(album, artist, @lastfm)
    rescue
      @album = nil
    end
    
    unless @album
      not_found
    end
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @album }
    end
  end
end
