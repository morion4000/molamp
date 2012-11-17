class Chart
  attr_accessor :hyped_artists
  
  def hyped_artists
    result = []
    
    if @hyped_artists
      @hyped_artists.each do |artist|
        a = Artist.new
        a.name = artist['name']
        a.url = artist['url']
        a.image = artist['image'] 
        
        result.push a
      end
    end
    
    return result
  end
end