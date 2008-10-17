class Users < Application
  # provides :xml, :yaml, :js

  #def index
  #  @users = User.all
  #  display @users
  #end
  before :check_login, :only => [:show, :edit, :update, :destroy]
  def check_login
    #Merb.logger.warn(params[:id])
    #Merb.logger.warn((session[:user_id]).to_s)
    #Merb.logger.warn(logged_in?.to_s)
    #Merb.logger.warn((session[:user_id]==params[:id].to_i).to_s)
    redirect url(:index) unless logged_in? && session[:user_id]==params[:id].to_i
  end

  def show
    @user = User.get(params[:id])
    raise NotFound unless @user
    display @user
  end

  def new
    only_provides :html
    @user = User.new
    render
  end

  def edit
    only_provides :html
    @user = User.get(params[:id])
    raise NotFound unless @user
    render
  end

  def create
    @user = User.new(params[:user])
    Merb.logger.warn("User before save: #{@user.to_yaml}")
    if @user.save
      session[:user_id]=@user.id
      redirect url(:user, @user.id)
    else
      render :new
    end
  end

  def update
    @user = User.get(params[:id])
    raise NotFound unless @user
    if @user.update_attributes(params[:user]) || !@user.dirty?
      redirect url(:user, @user)
    else
      raise BadRequest
    end
  end

  def destroy
    @user = User.get(params[:id])
    raise NotFound unless @user
    if @user.destroy
      redirect url(:user)
    else
      raise BadRequest
    end
  end
  def feed
    only_provides :xml
    #Merb.logger.warn("params[:username]#{params.to_s}")
    raise NotFound unless @user = User.find_by_username(params[:username]) 
    #@user.update_tweets
    #@user.tweets.each do |t|
    #  t.delete_if_expired
    #  (t.title ||= find_site_title(t.website))?(t.update):(t.destroy)
    #end
    render
    
  end

end # Users
