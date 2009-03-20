class User

  include DataMapper::Resource

  has n, :tweets
  has n, :bad_sites

  property :username, String, :nullable => false, :unique => true, :format => /\w+/

  property :id, Integer, :serial => true, :nullabe => false

  property :pass_hash, String, :nullabe => false, :length => 48

  property :email, String, :nullable => false, :unique => true, :format => :email_address

  property :last_tweet_seen, Integer, :precision => 64

  property :token, String
  
  property :secret, String

  validates_with_method :validate_twitter_info
  def validate_twitter_info
    x = Twitter::Base.new self.username, self.password
    begin
      x.verify_credentials
      true
    rescue
      [false, "Twitter says your username and password are wrong. Make sure you're using your correct Twitter info and try again. If Twitter is down, you need to try again when it's up."]
    end
  end


  
  def self.consumer
    # The readkey and readsecret below are the values you get during registration
    #TODO get the real vals of these keys when Twitter gets TLM registered 
  OAuth::Consumer.new("M7TCLHwOLr9Wy0H0tkzyhg",
                      "mgVfkf9RFtFHEl2J5Kfes3OQ4M20HJ7PXLaUAGWLk2E",
                      { :site=>"http://twitter.com" })

  end
  def access_token
    @access_token ||= OAuth::AccessToken.new(User.consumer, self.token, self.secret)
  end
  def fetch_tweets(since = nil, page = 1)
    url = '/friends.xml?count=200'
    url += "&since_id=#{since}" if since
    url += "&page=#{page}" unless page.nil? || page == 1
    Hpricot.XML User.consumer.request(:get, url, self.access_token, {scheme => :query_string})
  end
  def get_tweets(since = nil, page=1)
    doc = self.fetch_tweets since, page
    (doc/:status).collect do |status|
      Tweet.new({:user_id=>self.id, :text=>(status/:text).inner_html, :created_at=>(status/:created_at).inner_html, :author=>(status/:user/:name).inner_html, :author_uname=>(status/:user/:author_uname).inner_html, :twitter_id=>(status/:id).inner_html})
    end
  end
  def update_tweets
    begin
      tweets = self.get_tweets
      last = self.last_tweet_seen
      self.last_tweet_seen = tweets[0].twitter_id.to_i if tweets[0]
      self.update
      #Merb.logger.warn tweets[0].object_id
      #Merb.logger.warn tweets[0].id
      page = 1
      tweet_page = [Tweet.new]
      unless last.nil? || last == 0
        until tweet_page.empty? || tweets.empty? || page>=5
          tweet_page =get_tweets(last, page+=1)# when page initially =1, this gets page 2.
          tweets += tweet_page
          Merb.logger.warn tweet_page.length
        end
      end
      tweets.reverse.each do |t|
        next unless t.author != self.username && Tweet.find_website(t.text) && self.passes_filter?(Tweet.find_website(t.text))
        t.title = self.find_site_title(Tweet.find_website(t.text))
        t.save #if t.user.screen_name != self.username && tweet.website
      end
    rescue
      Merb.logger.error("Exception #{$!} occurred")
      puts "#{$!} from the tweet-construction loop"
      return false
    end
    true
  end
  def expire_tweets
    self.tweets.each do |t|
      t.delete_if_expired
    end
  end
  def password
    crypt = User.crypt_obj
    return nil unless self.pass_hash
    return crypt.decrypt_string(Base64.decode64(self.pass_hash))
  end
  def password=(pass)
    crypt = User.crypt_obj
    self.pass_hash = Base64.encode64(crypt.encrypt_string(pass))
  end
  def self.crypt_obj
    require 'crypt/rijndael'
    Crypt::Rijndael.new((Merb.env=="production")?("odiosh4redhostingsomuch!merbcool"):("thiskey!"*2))
  end
  def change_to_rand_pass
    self.password=User.random_password
  end
  def self.random_password
    x = %w(! @ # $ % ^ & * - + = _ / < > ?)
    ("A".."Z").each{|c|
      x<<c
    }
    ("a".."z").each{|c|
      x<<c
    }
    ("0".."9").each{|c|
      x<<c
    }
    str=""
    ((rand*3+9).to_i).times do
      str<<x[(rand*x.length).to_i]
    end
    str
  end
  def meta_tweet_update
    self.update_tweets
    self.tweets.each do |t|
      next if t.delete_if_expired
      #begin
      (t.title ||= self.find_site_title(t.website))?(t.update):(self.log("got a nil title somehow"))
      #rescue Timeout::Error
#         t.title||="Title Not Found"
#         t.update rescue t.delete rescue next
#         next
#       end
    end
    true
  end
 def webpage_title(page)

   Merb.logger.warn("couldn't find the title") unless str = /<title>.+<\/title>/ =~ page

   return "Title Not Found" unless str

   $&[7...-8]

 end
 def find_site_title(uri)
   uri=uri_ify(uri)
   doc= nil
   title = nil
   begin
     timeout(10) do
       doc = open(uri)
     end
   rescue Timeout::Error
     self.log("timeout")
     title = "Title Not Found"
   rescue
     self.log($!)
     title = "Title Not Found"
   end
   return title if title
   str = /<title>.+<\/title>/ =~ doc.read
   return (str)?($&[7...-8]):("Title Not Found")
  end

  def uri_ify(str)
    str=((/https?:\/\//=~str)||(/ftp:\/\//=~str))?(str):("http://#{str}")
    str+='/' unless str[10] && /\// =~str[10..-1]
    str
  end
  def log(str)
    Merb.logger.error(str.to_s)
  end
  def self.authenticate(username, pass)
    if user = User.find_by_username(username)
      user.password==pass
    else
      false
    end
  end


  def passes_filter?(url)
    self.bad_sites.each do |bad|
      return false if bad.pattern =~ url
    end
    true
  end
  after :save do
    self.meta_tweet_update
  end
end

