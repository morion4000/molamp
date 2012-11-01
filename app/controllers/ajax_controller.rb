class AjaxController < ApplicationController
  def scrobble_mode
    mode = params[:mode]
    
    if mode == 'on'
      current_user.scrobble_mode = true
    else
      current_user.scrobble_mode = false
    end
    
    current_user.save
    
    respond_to do |format|
      format.html { render :json => true }
    end
  end
  
  def activity_mode
    mode = params[:mode]
    
    if mode == 'on'
      current_user.activity_mode = true
    else
      current_user.activity_mode = false
    end
    
    current_user.save
    
    respond_to do |format|
      format.html { render :json => true }
    end
  end
end
