class Tweet
  include DataMapper::Resource

  property :id, Serial
  property :user_id, Integer, :nullable => false
  property :text, String, :nullable => false, :length => 170
  property :created_at, DateTime, :nullable => false
  property :title, String, :length => 1000
  property :author, String, :length => 35, :default => nil
  property :author_uname, String, :length => 15, :default => nil
  property :twitter_id, Integer, :default => nil

  def delete_if_expired
    self.destroy if (Time.now - 4.days) > self.created_at 
  end
  def website
    Tweet.find_website(self.text)
  end
  def self.find_website(str)
    /(http:\/\/|www\.)\S+\.[A-z]{2,3}\S*/ =~ str
    return nil if $&.nil?
    x = $&
    #x = x[0...-1] while /[\.\)\]!\?]/ =~ x[-1].chr
    x = x[0...-1] until x.blank?||/[\w\/]/ =~ x[-1].chr
    return nil if x.blank?
    x
  end
  def html_entities_to_xml(str)
    x = HTMLEntities.new
    x.encode(x.decode(str), :decimal)
  end
  after :text= do
    self.attribute_set(:text, html_entities_to_xml(self.text.gsub('&amp;', '&'))) if self.text
  end
  after :author= do
    self.attribute_set(:author, html_entities_to_xml(self.author.gsub('&amp;', '&'))) if self.author
  end
  after :title= do
    self.attribute_set(:title, html_entities_to_xml(self.title)) if self.title
    true
  end
end
