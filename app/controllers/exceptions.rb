class Exceptions < Application
  
  # handle NotFound exceptions (404)
  def not_found
    #params[:exception] ||== "404 Not Found"
    @exception = "404 Not Found"
    render :format => :html
  end

  # handle NotAcceptable exceptions (406)
  def not_acceptable
    #params[:exception] ||= "Not Acceptable"
    @exception = "Not Acceptable"
    render :format => :html
  end

end
