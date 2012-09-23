class Artist 
  attr_accessor :name, :lastfm
  
  def initialize(name, lastfm)
    @name = name
    @lastfm = lastfm
  end
  
  def info
    Rails.cache.fetch("/artists/#{@name}/info", :expires_in => 7.days) do
      @lastfm.artist.get_info(@name)
    end
  end
  
  def top_tracks
    Rails.cache.fetch("/artists/#{@name}/top_tracks", :expires_in => 7.days) do
      @lastfm.artist.get_top_tracks(:artist => @name, :limit => 30)
    end
  end
  
  def top_albums
    Rails.cache.fetch("/artists/#{@name}/top_albums", :expires_in => 7.days) do
      @lastfm.artist.get_top_albums(:artist => @name, :limit => 10)
    end
  end
  
  def find(*name)
    if !name
      name = @name  
    end
    
    return @lastfm.artist.search(:artist => @name)
  end
end
