class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:show, :edit, :update]
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "Account registered!"
      redirect_back_or_default account_url
    else
      render :action => :new
    end
  end
  
  def show
    @user = @current_user
    
    if cookies[:lastfm_session]
      begin
        @query = cookies.signed[:lastfm_user]
        
        user = LastfmUser.new(@query, @lastfm)
        
        @top_artists = user.top_artists
        @lastfm_user = user.info
      rescue
        @top_artists  = nil
        @lastfm_user = nil
      end
    end
    
    if cookies[:facebook_session]
      @profile = @facebook.get_object('me')
    end
    
   respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @profile }
   end
  end

  def edit
    @user = @current_user
  end
  
  def update
    @user = @current_user # makes our views "cleaner" and more consistent
    if @user.update_attributes(params[:user])
      flash[:notice] = "Account updated!"
      redirect_to account_url
    else
      render :action => :edit
    end
  end
end