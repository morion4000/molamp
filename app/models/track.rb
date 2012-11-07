class Track
  attr_accessor :id, 
                :mbid, 
                :name, 
                :artist, 
                :image, 
                :url, 
                :duration, 
                :album, 
                :listeners,
                :playcount, 
                :toptags, 
                :wiki
   
  def image(size)  
    image = Image.new
    image.image = @image
    
    return image.get(size)
  end
  
  def artist
    a = Artist.new
    a.name = @artist['name']
    
    return a
  end
  
  def album
    a = Album.new
    a.name = @album['name']
    a.image = @album['image']
    
    return a
  end
end