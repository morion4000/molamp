class AjaxController < ApplicationController
  def scrobble
    unless current_user
      render :nothing => true and return
    end
    
    artist = params[:artist]
    track = params[:track]
    result = nil
    
    if current_user.lastfm_token and current_user.scrobble_mode === true and Rails.env.production?
      t = LastfmTrack.new(track, artist, @lastfm)
      
      result = t.scrobble
    end
    
    render :json => result
  end

  def activity
    unless current_user
      render :nothing => true and return
    end

    artist = params[:artist]
    track = params[:track]
    result = nil

    video_url = 'http://www.molamp.net/artists/' + artist.gsub(' ', '+') + '/_/' + track.gsub(' ', '+')

    sleep(10)

    if current_user.facebook_token and current_user.activity_mode === true and Rails.env.production?
      result = @facebook.put_connections('me', 'video.watches', :video => video_url)
      #thread = Thread.new {
      #Thread.current[:output] = 
      #}
    end

    render :json => result and return
  end

  def activity_delete
    unless current_user
      render :nothing => true and return
    end
    
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
    unless current_user
      render :nothing => true and return
    end
    
    mode = params[:mode]
    
    if mode == 'true'
      current_user.scrobble_mode = true
    else
      current_user.scrobble_mode = false
    end
    
    current_user.save
    
    render :nothing => true
  end
  
  def activity_mode
    unless current_user
      render :nothing => true and return
    end
    
    mode = params[:mode]
    
    if mode == 'true'
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
