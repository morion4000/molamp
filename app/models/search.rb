class Search
  attr_accessor :totalResults, 
                :startIndex, 
                :itemsPerPage, 
                :artistmatches

  def artistmatches
    result = []
    
    # if the search only has one result then lastfm sends a hash instead of an array
    if @artistmatches['results']['artistmatches']['artist'].is_a?(Hash)
      @artistmatches['results']['artistmatches']['artist'] = [@artistmatches['results']['artistmatches']['artist']]
    end 
    
    if @artistmatches['results']['artistmatches']['artist']
      @artistmatches['results']['artistmatches']['artist'].each do |artist|
        a = Artist.new
        a.name = artist['name']
        a.url = artist['url']
        a.image = artist['image']
        a.listeners = artist['listeners']
        
        result.push a
      end
    end
    
    return result
  end

end