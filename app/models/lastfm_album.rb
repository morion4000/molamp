class LastfmAlbum < Album
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
    @url = info['url']
    @releasedate = info['releasedate']
    @image = info['image']
    @listeners = info['listeners']
    @playcount = info['playcount']
    @toptags = info['toptags']
    @tracks = info['tracks']
  end
  
  def get_info
    Rails.cache.fetch("/albums/#{@artist}/#{@name}#info", :expires_in => 7.days, :compress => true) do
      @lastfm.album.get_info(:artist => @artist, :album => @name)
    end
  end
end