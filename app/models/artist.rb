class Artist 
  attr_accessor :name, :lastfm
  
  def initialize(name, lastfm)
    @name = name
    @lastfm = lastfm
  end
  
  def info
    return @lastfm.artist.get_info(@name)
  end
  
  def top_tracks
    return @lastfm.artist.get_top_tracks(@name)
  end
  
  def find(*name)
    if !name
      name = @name  
    end
    
    return @lastfm.artist.search(@name)
  end
end
