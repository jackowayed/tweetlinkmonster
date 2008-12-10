module Merb
  module UsersHelper
    
    def httpified_link(url)
      ((/.{3,5}:\/\//=~url)==0)?(url):("http://#{url}")
    end
    def tweet_link(user, id)
      link_to "#{user}:", "http://www.twitter.com/#{user}/status/#{id}"
    end
  end
end # Merb
