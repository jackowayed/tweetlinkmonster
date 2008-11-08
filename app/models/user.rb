class User
  include DataMapper::Resource

  has n, :tweets

  property :username, String, :nullable => false, :unique => true

  property :id, Integer, :serial => true, :nullabe => false

  property :pass_hash, String, :nullabe => false, :length => 48

  property :email, String, :nullable => false, :unique => true, :format => :email_address

  property :last_tweet_seen, Integer, :precision => 64

  validates_with_method :validate_twitter_info
  def validate_twitter_info
    x = Twitter::Base.new self.username, self.password
    begin
      x.verify_credentials
      true
    rescue
      [false, "Twitter says your username and password are wrong. Make sure you're suing your correct Twitter info and try again. If Twitter is down, you need to try again when it's up."]
    end
  end

  def get_tweets(twitter_obj, page = 1)
    Merb.logger.warn "get_tweets called"
    options = {:page => page}
    options[:since_id] = self.last_tweet_seen if self.last_tweet_seen
    Merb.logger.warn options.to_s
    twitter_obj.timeline(:friends, options)
  end
  def update_tweets
    x = Twitter::Base.new(self.username, self.password)
    begin
      x.verify_credentials
      tweets = self.get_tweets(x)
      last = self.last_tweet_seen
      self.last_tweet_seen = tweets[0].id.to_i if tweets[0]
      self.update
      #Merb.logger.warn tweets[0].object_id
      #Merb.logger.warn tweets[0].id
      page = 1
      tweet_page = [nil]
      unless last.nil? || last == 0
        until tweet_page.empty? || tweets.empty? || page==10
          tweet_page =get_tweets(x, page+=1)
          tweets += tweet_page
          Merb.logger.warn tweet_page.length
        end
      end
      tweets.each do |t|
        tweet = Tweet.new({:user_id => self.id, :text => t.text, :created_at => t.created_at, :author => t.user.name})
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

  def find_site_title(url)
    uri=uri_ify(url)
    doc= nil 
    title = nil
    begin
      timeout(5) do
        doc = Hpricot(open(uri))
      end
    rescue Timeout::Error
      self.log("timeout")
      title = "Title Not Found"
    end
    return title if title
    title = (doc/"title").innerHTML
    return (title=="")?("Title Not Found"):(title)
  end
      
  def uri_ify(str)
    str=((/https?:\/\//=~str)||(/ftp:\/\//=~str))?(str):("http://#{str}")
    str+='/' unless str[10] && /\// =~str[10..-1]
    str
  end
#   def webpage_title(page)
#     Merb.logger.warn("couldn't find the title") unless str = /<title>.+<\/title>/ =~ page
#     return "Title Not Found" unless str
#     $&[7...-8]
#   end

#   #from ruby-doc.org adapted by Michael
#   def fetch(uri_str, limit = 10)
#     # You should choose better exception.
#     return nil if limit == 0

#     begin
#       url = self.parse(uri_str)
#       req = Net::HTTP::Get.new(url.path)
#       #req.content_length=20
#       req.range = (0..2000)
#       response = Net::HTTP.new(url.host, url.port).start {|http| http.request(req) } 
#       Merb.logger.warn(response.to_s)
# #      return response
#     rescue Timeout::Error
#       Merb.logger.warn($!)
#       return false
#     rescue
#       Merb.logger.warn($!)
#       return false
#     end
#     #return response
#     case response
#       when Net::HTTPSuccess     then response
#       when Net::HTTPOK          then response
#       when Net::HTTPPartialContent then response
#       when Net::HTTPRedirection then self.fetch(response['location'], limit - 1)
#       when Net::HTTPMovedPermanently then  self.fetch(response['location'], limit - 1)
#       when Net::HTTPFound then self.fetch(response['location'], limit-1)
#     else
#       Merb.logger.warn("some weird response")
#       return nil
#     end
#   end

#   def find_site_title(url)
#     x = self.fetch(url)
#     return nil if x.nil?
#     return "Title not found" if x==false
#     self.webpage_title(x.body)#.gsub(/&[A-z].{2,9};/, "-")
#   end
#   def parse(str)
#     str+='/' unless str[11] && /\// =~str[11..-1]
#     URI.parse((/^https?:\/\//=~str)?(str):("http://#{str}"))
#   end
  def log(str)
    Merb.logger.warn(str.to_s)
  end

  #validates_uniqueness_of :username

end

