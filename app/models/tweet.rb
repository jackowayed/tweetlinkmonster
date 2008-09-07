class Tweet
  include DataMapper::Resource

  property :id, Integer, :primary => true
  property :user_id, Integer, :nullable => false
  property :text, String, :nullable => false

end
