class LastfmTrack < Track
  attr_accessor :lastfm
  
  def initialize(name, artist, lastfm)
    @lastfm = lastfm
    
    @name = name
    @artist = artist
    
    info = self.get_info
    
    @id = info['id']
    @mbid = info['mbid']
    @name = info['name']
    @artist = info['artist']
    @image = info['image']
    @url = info['url']
    @duration = info['duration']
    @album = info['album']
    @listeners = info['listeners']
    @playcount = info['playcount']
    @toptags = info['toptags']
    @wiki = info['wiki']
  end
  
  def get_info
    Rails.cache.fetch("/artists/#{@artist}/_/#{@name}#info", :expires_in => 7.days, :compress => true) do
      return @lastfm.track.get_info(:artist => @artist, :track => @name)
    end
  end
  
  def get_similar
    return @lastfm.track.get_similar(:artist => @artist, :track => @name)
  end
  
  def scrobble
      return @lastfm.track.scrobble(:artist => @artist, :track => @name)
  end
end
