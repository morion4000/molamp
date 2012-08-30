class Album 
  attr_accessor :name, :artist, :lastfm
  
  def initialize(name, lastfm)
    @name = name
    @lastfm = lastfm
  end
  
  def find(*name)
    #return @lastfm.album.search(@name)
    return nil
  end
end
