class Artist
  attr_accessor :id, 
                :mbid, 
                :name, 
                :url, 
                :image, 
                :listeners, 
                :plays, 
                :similar, 
                :tags, 
                :bio
                
  def image(size)  
    image = Image.new
    image.image = @image
    
    return image.get(size)
  end
  
  def similar
    result = []
    
    # if the album only has one track then lastfm sends a hash instead of an array
    if @similar['artist'].is_a?(Hash)
     @similar['artist'] = [@similar['artist']]
    end
    
    @similar['artist'].each do |artist|
      a = Artist.new
      a.name = artist['name']
      a.image = artist['image']  
      
      result.push a
    end
    
    return result
  end
  
  def top_tracks
    result = []
    
    # if the artist only has one artist then lastfm sends a hash instead of an array
    if @top_tracks.is_a?(Hash)
      @top_tracks = [@top_tracks]
    end
    
    @top_tracks.each do |track|
      t = Track.new
      t.name = track['name']
      
      # some songs don't have an mbid so i'll generate one
      unless track['mbid'].is_a?(String)
        track['mbid'] = '_' + Digest::MD5.hexdigest(track['name'] + @artist)
      end
      
      t.mbid = track['mbid']
      
      # if duration is a hash it means that duration is not set
      if track['duration'].is_a?(Hash)
        track['duration'] = '0'
      end
      
      t.duration = track['duration']
      t.image = track['image'] 
      
      result.push t
    end
    
    return result
  end
  
  def top_albums
    result = []
    
    # if the artist only has one album then lastfm sends a hash instead of an array
    if @top_albums.is_a?(Hash)
      @top_albums = [@top_albums]
    end
    
    @top_albums.each do |album|
      a = Album.new
      a.name = album['name']
      a.url = album['url']
      a.image = album['image'] 
      a.playcount = album['playcount']
      
      result.push a
    end
    
    return result
  end
end