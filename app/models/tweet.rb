class Tweet
  include DataMapper::Resource

  property :id, Integer, :key => true
  property :user_id, Integer, :nullable => false
  property :text, String, :nullable => false
  property :created_at, DateTime, :nullable => false

  def delete_if_expired
    self.destroy if (Time.now - 1.week) > self.created_at 
  end
  def website
    /(http:\/\/|www)\S+\.[A-z][A-z][A-z]\S*/ =~ self.text
    return nil if $&.nil?
    #($&[-1]=="."
  end

end
