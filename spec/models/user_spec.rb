module UserSpecHelper 
  def valid_user_attributes
    { :username => "twitter",
      :password => "p4ssw0rd",
      :email => "info@twitter.com"}
  end
end
      
  
require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe User do

  include UserSpecHelper

  before(:each) do
    @user = User.new
  end
  it "should have specs"
  it "should require a username" do
    @user.attributes = valid_user_attributes.except(:username)
    @user.save.should == false
    @user.username = "twitter"
    @user.save.should ==true
  end

end
