class LastfmChart < Chart
  attr_accessor :lastfm
  
  def initialize(lastfm)
    @lastfm = lastfm
    
    @hyped_artists = self.get_hyped_artists
  end
  
  def get_hyped_artists
    Rails.cache.fetch("/charts#hyped_artists", :expires_in => 7.days, :compress => true) do
      return @lastfm.chart.get_hyped_artists(:limit => 24)
    end
  end
end
