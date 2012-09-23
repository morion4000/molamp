class Album 
  attr_accessor :name, :artist, :lastfm
  
  def initialize(name, artist, lastfm)
    @name = name
    @artist = artist
    @lastfm = lastfm
  end
  
  def info
    Rails.cache.fetch("/albums/#{@artist}/#{@name}/info", :expires_in => 7.days) do
      @lastfm.album.get_info(:artist => @artist, :album => @name)
    end
  end
  
  def find(*name)
    #return @lastfm.album.search(@name)
    return nil
  end
end
