module UserSpecHelper 
  def valid_fake_user_attributes
    { :username => "twitter",
      :password => "p4ssw0rd",
      :email => "info@twitter.com"}
  end
  def valid_real_user_attributes
    { :username => "testing42",
      :password => "testme",
      :email => "daniel@jackoway.net"}
  end
end
      
  
require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe User do

  include UserSpecHelper

  before(:each) do
    @user = User.new
  end
  after(:each) do
    @user.destroy
  end
  it "should run specs and fail" do
    true.should_not == "false"
  end
  it "should require a username" do
    @user.attributes = valid_fake_user_attributes.except(:username)
    @user.save.should == false
    @user.username = "twitter"
    @user.save.should ==true
  end
  it "should return false for #get_tweets with a fake user" do
    @user.attributes = valid_fake_user_attributes
    @user.update_tweets.should be_false
  end
  it "should return true for #get_tweets with a real user" do
    @user.attributes = valid_real_user_attributes
    @user.update_tweets.should be_true
  end



#  it "should complain with a bad username/password" do
#    @user.attributes = valid_fake_user_attributes
#    @user.update_tweets.should raise Twitter::CantConnect
#  end
  
end
