class Album 
  attr_accessor :name, :artist, :lastfm
  
  def initialize(name, artist, lastfm)
    @name = name
    @artist = artist
    @lastfm = lastfm
  end
  
  def info
    return @lastfm.album.get_info(:artist => @artist, :album => @name)
  end
  
  def find(*name)
    #return @lastfm.album.search(@name)
    return nil
  end
end
