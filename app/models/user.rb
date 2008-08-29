class User
  include DataMapper::Resource

  property :username, String
  property :id, Integer, :serial => true
  property :password, String

end
