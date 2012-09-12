class UsersController < ApplicationController
  # GET /users
  def index
    redirect_to '/'
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @query = params[:id]
    
    begin
      user = User.new(@query, @lastfm)
      
      @top_artists = user.top_artists
      @user = user.info
    rescue
      @top_artists  = nil
    end
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @top_artists }
    end
  end
end