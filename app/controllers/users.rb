class Users < Application
  # provides :xml, :yaml, :js

  #def index
  #  @users = User.all
  #  display @users
  #end
  before :check_login, :only => [:show, :edit, :update, :destroy, :batch_update_bad_sites]
  def check_login
    #Merb.logger.warn(params[:id])
    #Merb.logger.warn((session[:user_id]).to_s)
    #Merb.logger.warn(logged_in?.to_s)
    #Merb.logger.warn((session[:user_id]==params[:id].to_i).to_s)
    redirect(url(:index), :message => "You must be logged in to go there") unless logged_in? && session[:user_id]==params[:id].to_i
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

  def create(par)
    @user = User.new((par ? par : params[:user]))
    Merb.logger.warn("User before save: #{@user.to_yaml}")
    
    
    if @user.save
      session[:user_id]=@user.id
      redirect url(:user, @user.id), :message => "Now fill in your email and password so that you can log in and change settings in the future."
    else
      @_message = error_message_encode @user
      render :new
    end
    
    
    
  end

  def update
    @user = User.get(params[:id])
    raise NotFound unless @user
    Merb.logger.error("LOOK AT THIS!!!!!!!!!!!!!")
    Merb.logger.error(params[:user][:username].to_s)
    if @user.update_attributes(params[:user]) || !@user.dirty?
      @_message = "Your account has been successfully updated."
      redirect url(:user, @user), :message => @_message
    else
      @_message = error_message_encode @user
      redirect url(:user, @user), :message => @_message
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
    only_provides :xml, :atom
    #Merb.logger.warn("params[:username]#{params.to_s}")
    raise NotFound unless @user = User.find_by_username(params[:username]) 
    #@user.update_tweets
    #@user.tweets.each do |t|
    #  t.delete_if_expired
    #  (t.title ||= find_site_title(t.website))?(t.update):(t.destroy)
    #end
    render
    
  end
  def error_message_encode(user)
    mess = ""
    @user.errors.full_messages.each do |err|
      mess << err << ";;;"
    end
    mess
  end
  def batch_update_bad_sites
    @user = User.get(logged_in?)
    raise NotFound unless @user

    #Merb.logger.fatal(params[:user][:bad_sites][1].to_s)
    #Merb.logger.fatal(params[:user][:bad_sites][0.to_s].to_s)
    #Merb.logger.fatal((params[:user][:bad_sites]['1']).to_s)

    #Merb.logger.fatal(params[:user][:bad_site].to_s)
    params[:user][:bad_sites].each do |ind,reg|
      Merb.logger.fatal(ind.to_s)
      Merb.logger.fatal(reg.to_s)
      bad_sites = @user.bad_sites
      unless reg == "" || reg == "//" || reg==" "
        if a = bad_sites[ind.to_i]
          a.pattern=reg
          a.update if a.dirty?
        else
          a = BadSite.new(:pattern => reg, :user_id => @user.id)
          unless a.save
            redirect resource(@user), :message => "Blocked Site #{reg.to_good_s} is invalid."
          end
        end
      else
        if a = bad_sites[ind.to_i]
          a.destroy
        end       
      end

 
    end
    redirect resource(@user), :message => "Blacklist updated successfully"
  end
  def send_for_oauth_approval
    @request_token = User.consumer.get_request_token
    session[:request_token] = @request_token.token
    session[:request_token_secret] = @request_token.secret
    # Send to twitter.com to authorize
    redirect @request_token.authorize_url
  end
  def callback
    @request_token = OAuth::RequestToken.new(User.consumer,
                                             session[:request_token],
                                             session[:request_token_secret])

    # Exchange the request token for an access token.
    @access_token = @request_token.get_access_token
    
    @response = User.consumer.request(:get, '/account/verify_credentials.json',
                                      @access_token, { :scheme => :query_string })
    case @response
    when Net::HTTPSuccess
      user_info = JSON.parse(@response.body)
      
      unless user_info['screen_name']
        redirect url(:index), :message => "Authentication failed"
      end

      # We have an authorized user, use the create method like a rational person
      @user_params = { :username => user_info['screen_name'],
                         :token => @access_token.token,
                         :secret => @access_token.secret }
      #nil.id ==4 wtf?
      @user = User.first(:username => user_info['screen_name'])
      if @user
        #update
        raise NotFound unless @user
        if @user.update_attributes(@user_params) || !@user.dirty?
          @_message = "Your account has been successfully updated."
          redirect url(:user, @user), :message => @_message
        else
          @_message = error_message_encode @user
          redirect url(:user, @user), :message => @_message
        end
      else
        #create
        @user = User.new @user_params
        Merb.logger.warn("User before save!!!: #{@user.to_yaml}")
        
    
        if @user.save
          session[:user_id]=@user.id
          redirect url(:user, @user.id), :message => "Now fill in your email and password so that you can log in and change settings in the future."
        else
          @_message = error_message_encode @user
          render :new
        end
      end
        
        
      
    else
      Merb.logger.error "Failed to get user info via OAuth!!"
      # The user might have rejected this application. Or there was some other error during the request.

      redirect url(:index), :message => "Authentication failed"
    end
  end
end # Users
