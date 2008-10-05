class Main < Application

  # ...and remember, everything returned from an action
  # goes to the client...
  def index
    render
  end
  def login
    @use = User.new
    #redirect url(:controller => 'main', :action => 'index')
    render
  end
  def verify_login
    @user = User.find_by_username(params[:user][:username])
    session[:user_id]=@user.id if @user && @user.password==params[:user][:password]
    session[:failed_login?]=false
    return redirect url(:user, @user.id) if logged_in?
    session[:failed_login?]=true
    redirect url(:login)
    
  end
    
  
end
