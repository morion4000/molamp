class Image
  attr_accessor :image, :size
  
  def get(size)
    @size = size
    
    # return the full path of the noimage as it might be used in javascript as well 
    if @size < 3
      result = '/assets/noimage.jpg'
    else
      result = '/assets/noimage_big.jpg'
    end
    
    # TODO: try a smaller and smaller image until there are no more image
    if @image and @image[size]['content'] != nil 
      result = @image[size]['content']
    end
    
    return result
  end
  
end