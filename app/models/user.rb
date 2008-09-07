class User
  include DataMapper::Resource

  has n, :tweets

  property :username, String, :nullable => false, :unique => true

  property :id, Integer, :serial => true, :nullabe => false

  property :password, String, :nullabe => false

  property :email, String, :nullable => false, :unique => true, :format => :email_address

  property :last_tweet_seen, Integer

  def get_tweets(twitter_obj, page = 1)
    options = {}
    options[:since_id] = self.last_tweet_seen if self.last_tweet_seen
    tweets = twitter_obj.timeline(:friends, options)
  end
  def update_tweets
    x = Twitter::Base.new(self.username, self.password)
    begin
      x.verify_credentials
      tweets = self.get_tweets(x)
      page = 1
      unless self.last_tweet_seen.nil? || self.last_tweet_seen == 0
        tweets += get_tweets(page+=1) unless tweets[-1].id == self.last_tweet_seen
      end
      tweets.each{|t|
        tweet = Tweet.new{:id => t.id, :user_id = self.id, text => t.text} if website?(t.text)
        tweet.save
      }
    rescue
      Merb.logger.warn("Exception #{$!} occurred")
      return false
    end
    return true
  end
  def website?(str)
    /.*\.[A-z][A-z][A-z].*/
  end

  #validates_uniqueness_of :username

end
