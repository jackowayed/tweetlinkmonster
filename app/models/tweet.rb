class Tweet
  include DataMapper::Resource

  property :id, Serial
  property :user_id, Integer, :nullable => false
  property :text, String, :nullable => false, :length => 140
  property :created_at, DateTime, :nullable => false
  property :title, String, :length => 1000

  def delete_if_expired
    self.destroy if (Time.now - 1.week) > self.created_at 
  end
  def website
    /(http:\/\/|www\.)\S+\.[A-z]{3}\S*/ =~ self.text
    return nil if $&.nil?
    x = $&
    #x = x[0...-1] while /[\.\)\]!\?]/ =~ x[-1].chr
    x = x[0...-1] until x.blank?||x[-1].chr =~ /[\w\/]/
    return nil if x.blank?
    x
  end
  def html_entities_to_xml(str)
    x = HTMLEntities.new
    x.encode(x.decode(str), :decimal)
  end
  after :text= do
    self.attribute_set(:text, html_entities_to_xml(self.text)) if self.text
  end
  after :title= do
    self.attribute_set(:title, html_entities_to_xml(self.title)) if self.title
    true
  end
end
