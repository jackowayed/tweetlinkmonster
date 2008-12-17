class BadSite
  include DataMapper::Resource
  
  belongs_to :user
  property :id, Serial
  property :pattern, Regexp, :nullable => false 

  def matches?(str)
    self.pattern =~ str
  end


end
