class Tweet
  include DataMapper::Resource

  property :id, Serial
  property :user_id, Integer, :nullable => false
  property :text, String, :nullable => false, :length => 140
  property :created_at, DateTime, :nullable => false

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

end
