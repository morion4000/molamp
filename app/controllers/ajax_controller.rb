class AjaxController < ApplicationController
  def scrobble
    artist = params[:artist]
    track = params[:track]
    result = nil
    
    if current_user.lastfm_token and current_user.scrobble_mode === true# and Rails.env.production?
      t = LastfmTrack.new(track, artist, @lastfm)
      
      result = t.scrobble
    end
    
    render :json => result
  end
  
  def activity
    artist = params[:artist]
    track = params[:track]
    queue = Queue.new
    queue << nil
    
    video_url = 'http://www.molamp.net/artists/' + artist.gsub(' ', '+') + '/_/' + track.gsub(' ', '+')
    
    if current_user.facebook_token and current_user.activity_mode === true and Rails.env.production?
      begin
        Thread.new {
          queue << @facebook.put_connections('me', 'video.watches', :video => video_url)
        }
      rescue
        queue << nil
      end
    end
    
    render :json => queue.top 
  end
  
  def activity_delete
    id = params[:id]
    result = nil
    
    if current_user.facebook_token and current_user.activity_mode === true
      begin
        result = @facebook.delete_object(id)
      rescue
        result = nil
      end
    end
    
    render :json => result
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
  
  def autocomplete
    query = params[:query]
    result = []
    
    begin
      response = @lastfm.artist.search(:artist => query, :limit => 5)
      
      if response
        response['results']['artistmatches']['artist'].each do |artist|
          result.push artist['name']
        end
      end
    rescue
      result = []
    end
    
    render :json => result 
  end
  
  def get_image
    uri = URI.parse(params[:url])
    response = Net::HTTP.get_response(uri)
        
    send_data(response.body , :filename => 'image.png', :type=> 'image/png')
  end
end
