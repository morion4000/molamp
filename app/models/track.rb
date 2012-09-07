class Track 
  attr_accessor :name, :artist, :mbid, :lastfm
  
  def initialize(name, artist, lastfm)
    @name = name
    @artist = artist
    @lastfm = lastfm
  end
  
  def info
    return @lastfm.track.get_info(:artist => @artist, :track => @name)
  end
  
  def similar
    return @lastfm.track.get_similar(:artist => @artist, :track => @name)
  end
end
