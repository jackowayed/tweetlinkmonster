module TitleParse
  def webpage_title(page)
    str = /<title>.+?<\/title>/ =~ page
    return "Title Not Found" unless str
    $&[7...-8]
  end
end
