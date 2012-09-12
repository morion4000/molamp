class User 
  attr_accessor :name, :lastfm
  
  def initialize(name, lastfm)
    @name = name
    @lastfm = lastfm
  end
  
  def info
    return @lastfm.user.get_info(:user => @name)
  end
  
  def top_artists
    return @lastfm.user.get_top_artists(:user => @name, :limit => 30)
  end
end
