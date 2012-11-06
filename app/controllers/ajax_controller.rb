class AjaxController < ApplicationController
  def scrobble
    artist = params[:artist]
    track = params[:track]
    result = {:result => 'failed'}
    
    if current_user.lastfm_token and current_user.scrobble_mode === true and Rails.env.production?
      tracks = Track.new(track, artist, @lastfm)
      
      tracks.scrobble
    end
    
    render :nothing => true
  end
  
  def activity
    artist = params[:artist]
    track = params[:track]
    
    video_url = 'http://www.molamp.net/artists/' + artist.gsub(' ', '+') + '/_/' + track.gsub(' ', '+')
    
    if current_user.facebook_token and current_user.activity_mode === true and Rails.env.production?
      Thread.new {
        @facebook.put_connections('me', 'video.watches', :video => video_url)
      }
    end
    
    render :nothing => true
  end
  
  def scrobble_mode
    mode = params[:mode]
    
    if mode == 'on'
      current_user.scrobble_mode = true
    else
      current_user.scrobble_mode = false
    end
    
    current_user.save
    
    render :nothing => true
  end
  
  def activity_mode
    mode = params[:mode]
    
    if mode == 'on'
      current_user.activity_mode = true
    else
      current_user.activity_mode = false
    end
    
    current_user.save
    
    render :nothing => true
  end
  
  def get_image
    uri = URI.parse(params[:url])
    response = Net::HTTP.get_response(uri)
        
    send_data(response.body , :filename => 'image.png', :type=> 'image/png')
  end
end
