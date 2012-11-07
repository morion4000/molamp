class LastfmSearch < Search
  attr_accessor :artist, :lastfm
  
  def initialize(artist, lastfm)
    @lastfm = lastfm
    @artist = artist

    @artistmatches = artist_search
  end
  
  def artist_search
    Rails.cache.fetch("/search/artists/#{@artist}", :expires_in => 7.days, :compress => true) do
      @lastfm.artist.search(:artist => @artist, :limit => 10)
    end
  end
end
