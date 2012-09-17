module ApplicationHelper
  def url_to_lastfm(name)
    name.gsub(' ', '+')
  end
  
  def url_from_lastfm(name)
    name.gsub('+', ' ')
  end
  
  def convert_seconds_to_time(seconds, microdata)
    total_minutes = seconds / 1.minutes
    seconds_in_last_minute = seconds - total_minutes.minutes.seconds
    
    if microdata
      "#{total_minutes}M#{seconds_in_last_minute}S"
    else
      sprintf('%02d', total_minutes) + ':' + sprintf('%02d', seconds_in_last_minute) 
    end
   end
end
