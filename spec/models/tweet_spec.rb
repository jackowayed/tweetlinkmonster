require File.join( File.dirname(__FILE__), '..', "spec_helper" )
module TweetSpecHelper
  def new_tweet_attrs
    { :user_id => "1", 
      :text => "Hello",
      :created_at => Time.now,
      :id => 555103269}
  end
  def old_tweet_attrs
    x = new_tweet_attrs
    x[:created_at] = Time.now - 2.weeks
    x
  end
end
describe Tweet do

  include TweetSpecHelper

  before(:each) do
    @tweet = Tweet.new
  end
  after(:each) do
    @tweet.destroy
  end
  #it "should have specs"
  it "should delete itself on #delete_if_expired if it is older than 7 days" do 
    @tweet.attributes = old_tweet_attrs
    @tweet.save
    @tweet.delete_if_expired
    @tweet.new_record?.should be_true
  end
  it "should not delete itself on #delete_if_expired if it is less than 7 days old" do
    @tweet.attributes = new_tweet_attrs
    @tweet.save
    @tweet.delete_if_expired
    @tweet.new_record?.should be_false
  end
  it "should return a website for a www website" do
    @tweet.text = "stuff and www.google.com and stuff"
    @tweet.website.should == "www.google.com"
  end
  it "should return a website for an http:// website" do
    @tweet.text = "stuff and http://google.com and stuff"
    @tweet.website.should == "http://google.com"
  end
  it "should return the full http:// for a http://www website" do
    @tweet.text = "stuff and http://www.google.com and stuff"
    @tweet.website.should == "http://www.google.com"
  end
  it "should not return a trailing . in a website" do
    @tweet.text = "stuff and http://www.google.com. and stuff"
    @tweet.website.should == "http://www.google.com"
  end
  it "should not return a trailing ) in a website" do
    @tweet.text = "stuff and http://www.google.com) and stuff"
    @tweet.website.should == "http://www.google.com"
  end
  it "should not return a trailing ] in a website" do
    @tweet.text = "stuff and http://www.google.com] and stuff"
    @tweet.website.should == "http://www.google.com"
  end
  it "should not return a trailing ! in a website" do
    @tweet.text = "stuff and http://www.google.com! and stuff"
    @tweet.website.should == "http://www.google.com"
  end
  it "should not return a trailing ? in a website" do
    @tweet.text = "stuff and http://www.google.com? and stuff"
    @tweet.website.should == "http://www.google.com"
  end
  it "should not return any trailing special character but /" do
    @tweet.text = "stuff and http://www.google.com&"
    @tweet.website.should == "http://www.google.com"
  end

end
