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
  
  def index
    @user = @current_user
  end
  
  def social
    @user = @current_user
    
    if current_user.lastfm_token
      begin
        @query = current_user.lastfm_username
        
        user = LastfmUser.new(@query, @lastfm)
        
        @lastfm_user = user.info
      rescue
        @lastfm_user = nil
      end
    end
    
    if current_user.facebook_token
      begin
        @profile = @facebook.get_object('me')
        @profile_pic = @facebook.get_picture('me')
      rescue
        @profile = nil
        @profile_pic = nil
      end
    end
    
   respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @profile }
   end
  end
  
  def show
    @user = @current_user
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