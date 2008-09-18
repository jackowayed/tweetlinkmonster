class User
  include DataMapper::Resource

  has n, :tweets

  property :username, String, :nullable => false, :unique => true

  property :id, Integer, :serial => true, :nullabe => false

  property :pass_hash, String, :nullabe => false, :length => 64

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
      last = self.last_tweet_seen
      self.last_tweet_seen = tweets[0].id
      self.update
      Merb.logger.warn(tweets[0].id)
      page = 1
      unless last.nil? || last == 0
        until tweets[-1].id == self.last_tweet_seen
          tweets += get_tweets(page+=1)
        end
      end
      tweets.each do |t|
        tweet = Tweet.new({:user_id => self.id, :text => t.text, :created_at => t.created_at})
        tweet.save if t.user.screen_name != self.username && tweet.website
      end
    rescue
      Merb.logger.error("Exception #{$!} occurred")
      puts $!
      return false
    end
    return true
  end
  def expire_tweets
    self.tweets.each do |t|
      t.delete_if_expired end
  end
  def password
    crypt = crypt_obj
    return nil unless self.pass_hash
    return crypt.decrypt_string(self.pass_hash)
  end
  def password=(pass)
    crypt = crypt_obj
    self.pass_hash = crypt.encrypt_string(pass)
  end
  def crypt_obj
    require 'crypt/rijndael'
    Crypt::Rijndael.new("thiskey!"*2)
  end

  #validates_uniqueness_of :username

end
