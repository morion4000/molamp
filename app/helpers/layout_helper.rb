module LayoutHelper
  def head(head)
    content_for(:head) { head.to_s }
  end
  
  def meta(meta)
    content_for(:meta) { meta.to_s }
  end
  
  def title(title)
    content_for(:title) { h title.to_s }
  end

  def description(description) 
    content_for(:description) { h truncate(Sanitize.clean(description), :length => 150).to_s }
  end
    
  def get_image(image, size)
    if size < 3
      result = '/assets/noimage.jpg'
    else
      result = '/assets/noimage_big.jpg'
    end
    
    if image and image[size]['content'] != nil 
      result = image[size]['content']
    end
    
    return result
  end
end