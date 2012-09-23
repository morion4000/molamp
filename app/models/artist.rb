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
    Rails.cache.fetch("/artists/#{@name}", :expires_in => 7.days) do
      @lastfm.artist.get_top_tracks(:artist => @name, :limit => 30)
    end
  end
  
  def top_albums
    return @lastfm.artist.get_top_albums(:artist => @name, :limit => 10)
  end
  
  def find(*name)
    if !name
      name = @name  
    end
    
    return @lastfm.artist.search(:artist => @name)
  end
end
