class Album
  attr_accessor :id, 
                :mbid, 
                :name, 
                :artist, 
                :url, 
                :releasedate, 
                :image, 
                :listeners, 
                :playcount, 
                :toptags, 
                :tracks
  
  def image(size)  
    image = Image.new
    image.image = @image
    
    return image.get(size)
  end
  
  def tracks
    result = []
    
    # if the album only has one track then lastfm sends a hash instead of an array
    if @tracks['track'].is_a?(Hash)
      @tracks['track'] = [@tracks['track']]
    end
    
    if @tracks['track']
      @tracks['track'].each do |track|
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
        
        result.push t
      end
    end
    
    return result
  end
end