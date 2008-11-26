module Merb
  module UsersHelper
    
    def httpified_link(url)
      ((/.{3,5}:\/\//=~url)==0)?(url):("http://#{url}")
    end
      
  end
end # Merb
