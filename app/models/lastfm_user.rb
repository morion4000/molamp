class LastfmUser 
  attr_accessor :name, :lastfm
  
  def initialize(name, lastfm)
    @name = name
    @lastfm = lastfm
    @group = 'mnml' 
  end
  
  def info
    Rails.cache.fetch("/users/#{@name}#info", :expires_in => 7.days, :compress => true) do
      @lastfm.user.get_info(:user => @name)
    end
  end
  
  def get_weekly_chart_list
    Rails.cache.fetch("/users/#{@group}#weekly_chart_list", :expires_in => 7.days, :compress => true) do
      @lastfm.user.get_weekly_chart_list(:group => @group)
    end
  end
  
  def top_artists
    Rails.cache.fetch("/users/#{@name}#top_artists", :expires_in => 7.days, :compress => true) do
      @lastfm.user.get_top_artists(:user => @name, :limit => 30)
    end
  end
end
