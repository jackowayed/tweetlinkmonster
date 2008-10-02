class Application < Merb::Controller
  before :dump_request
  def dump_request
    Merb.logger.info request.to_yaml
  end


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
      return nil
    end
    case response
    when Net::HTTPSuccess     then response
    when Net::HTTPRedirection then fetch(response['location'], limit - 1)
    else
      ""
    end
  end
  def find_site_title(url)
    return nil unless x = fetch(url)
    webpage_title(x.body)#.gsub(/&[A-z].{2,9};/, "-")
  end

end
