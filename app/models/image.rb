class Image
  attr_accessor :image, :size
  
  def initialize(i, size)
    @size = size
    
    if @size < 3
      @image = 'noimage.jpg'
    else
      @image = 'noimage_big.jpg'
    end
    
    if i and i[size]['content'] != nil 
      @image = i[size]['content']
    end
      
  end
  
end