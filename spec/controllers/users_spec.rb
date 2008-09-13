require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe "Users controller", "feed action", "fake user" do
  before(:each) do
    @controller=do_request(Users,:feed, {:username => "fake"})
  end
  #it "should implement the action" do
  #  @controller.should_not be_nil
  #end
  #it "should raise a NotFound" do
  #  @controller.)
  #end
  #it "should have @user with username the same as 

end
describe "Users controller", "feed action", "real user" do
  before(:all) do
    User.new({:username => "testing42", :password => "faker", :email => "fake@email.com"}).save 
  end
  before(:each) do
    @controller=do_request(Users,:feed, {:username => "fake"})
  end
    it "should create an @user ivar" do
    @controller.instance_variables.should include("@user")
  end 


end
