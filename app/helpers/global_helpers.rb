module Merb
  module GlobalHelpers
    # helpers defined here available to all views.  
    require 'net/http'
    require 'uri'
    def webpage_title(page)
      str = /<title>.+?<\/title>/ =~ page
      return "Title Not Found" unless str
      $&[7...-8]
    end
    #from ruby-doc.org
    def fetch(uri_str, limit = 10)
      # You should choose better exception.
      return "" if limit == 0
      
      begin
        response = Net::HTTP.get_response(URI.parse(uri_str))
      rescue
        return false
      end
      case response
      when Net::HTTPSuccess     then response
      when Net::HTTPRedirection then fetch(response['location'], limit - 1)
      else
        ""
      end
    end
    def find_site_title(url)
      return false unless x = fetch(url)
      webpage_title(x.body)
    end
    
    def logged_in?
      session[:user_id]
    end

    def login_or_out_link
      if logged_in?
        link_to "Logout", url(:logout)
      else
        link_to "Login", url(:login)      
      end
    end
    def sponsor_image
      link_to image_tag('sponsor_ivey.gif', :alt=>"Sponsored by Ivey & Brown consluting"), "http://iveyandbrown.com?tlm"
    end
    def sponsor_text
      link_to "Ivey & Brown", "http://iveyandbrown.com?tlm"

    end
  end
end
