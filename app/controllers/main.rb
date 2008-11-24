class Main < Application

  # ...and remember, everything returned from an action
  # goes to the client...
  def index
   #raise NotFound
    # @_message ||= "Flash messages (stuff like 'your account has been updated successfully') go here"
    render
  end
  def login
    
    @use = User.new
    #redirect url(:controller => 'main', :action => 'index')
    render
  end
  def log_user_in
    @user = User.find_by_username(params[:user][:username])
    session[:user_id]=@user.id if @user && @user.password==params[:user][:password]
    return redirect(url(:user, @user.id)) if logged_in?

    redirect url(:login), :message => 'Your username & password comination was incorrect'
    
  end
  def log_user_out
    session[:user_id]=nil
    redirect url(:index), :message => 'You have been logged out'
  end
    
  
end
