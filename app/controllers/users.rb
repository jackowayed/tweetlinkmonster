class Users < Application
  # provides :xml, :yaml, :js

  #def index
  #  @users = User.all
  #  display @users
  #end

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
      redirect url(:user, @user)
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
    raise NotFound unless @user = User.find_by_username(params[:username]) 
    @user.update_tweets
    @user.tweets.each do |t|
      t.delete_if_expired
      (t.title ||= find_site_title(t.website))?(t.update):(t.destroy)
    end
    render
    
  end
  def homepage
    render
  end

end # Users
