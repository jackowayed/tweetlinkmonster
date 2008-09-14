require File.join( File.dirname(__FILE__), '..', "spec_helper" )

#describe "Users controller", "feed action", "fake user" do
  #it "should implement the action" do
  #  @controller.should_not be_nil
  #end
  #it "should raise a NotFound" do
    #dispatch_to(Users,:feed, {:username => "fake"}).should raise_error Merb::ControllerExceptions::NotFound
  #end
  #it "should have @user with username the same as 

#end
describe "Users controller", "feed action", "real user" do
  before(:all) do
    User.new({:username => "testing42", :password => "testme", :email => "fake@email.com"}).save 
  end
  before(:each) do
    @controller=dispatch_to(Users,:feed, {:username => "testing42"})
  end
  it "should create an @user ivar" do
    @controller.instance_variables.should include("@user")
  end
  it "should delete any required tweets of the person" do 
    user.tweets.each{|t|
      t.stub!(:delete_if_expired).and_return(rand>0.7)
    }
  end
  def user
    @controller.instance_variable_get(:@user)
  end
  it "should call #update_tweets on @user" do
    user.stub!(:update_tweets).and_return(true)
  end
  


end
