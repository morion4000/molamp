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
    if size < 3
      result = 'noimage.jpg'
    else
      result = 'noimage_big.jpg'
    end
    
    # TODO: try a smaller and smaller image until there are no more image
    
    if @image and @image[size]['content'] != nil 
      result = @image[size]['content']
    end
    
    return result
  end
  
  def tracks
    result = []
    
    # if the album only has one track then lastfm sends a hash instead of an array
    if @tracks['track'].is_a?(Hash)
      @tracks['track'] = [@tracks['track']]
    end
    
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
    
    return result
  end
end