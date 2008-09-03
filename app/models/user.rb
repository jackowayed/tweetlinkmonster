class User
  include DataMapper::Resource

  property :username, String, :nullable => false, :unique => true

  property :id, Integer, :serial => true, :nullabe => false

  property :password, String, :nullabe => false

 property :email, String, :nullable => false, :unique => true, :format => :email_address


  #validates_uniqueness_of :username

end
