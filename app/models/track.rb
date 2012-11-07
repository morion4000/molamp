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
end