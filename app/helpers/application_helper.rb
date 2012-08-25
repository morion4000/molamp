module ApplicationHelper
  def url_to_lastfm(name)
    name.gsub(' ', '+')
  end
  
  def url_from_lastfm(name)
    name.gsub('+', ' ')
  end
end
