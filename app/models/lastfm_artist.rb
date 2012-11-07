class LastfmArtist < Artist
  attr_accessor :lastfm
  
  def initialize(name, lastfm, full_init)
    @lastfm = lastfm
    
    @name = name
        
    info = self.get_info
    
    @id = info['id']
    @mbid = info['mbid']
    @name = info['name']
    @url = info['url']
    @image = info['image']
    @listeners = info['stats']['listeners']
    @similar = info['similar']
    @tags = info['tags']
    @bio = info['bio']
    
    if full_init
      @top_tracks = get_top_tracks
      @top_albums = get_top_albums
    end
  end
  
  def get_info
    Rails.cache.fetch("/artists/#{@name}#info", :expires_in => 7.days, :compress => true) do
      @lastfm.artist.get_info(@name)
    end
  end
  
  def get_top_tracks
    Rails.cache.fetch("/artists/#{@name}#top_tracks", :expires_in => 7.days, :compress => true) do
      @lastfm.artist.get_top_tracks(:artist => @name, :limit => 30)
    end
  end
  
  def get_top_albums
    Rails.cache.fetch("/artists/#{@name}#top_albums", :expires_in => 7.days, :compress => true) do
      @lastfm.artist.get_top_albums(:artist => @name, :limit => 10)
    end
  end
end
