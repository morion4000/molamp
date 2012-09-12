module LayoutHelper
  def title(page_title, show_title = true)
    content_for(:title) { h(page_title.to_s) }
    @show_title = show_title
  end

  def show_title?
    @show_title
  end
  
  def description(description)
    content_for(:description) { h(description.to_s) }
  end
  
  def get_image(image, size)
    result = '/assets/noimage.jpg'
    
    if image and image[size]['content'] != nil 
      result = image[size]['content']
    end
    
    return result
  end
end