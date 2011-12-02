class String
  
  def to_url
    URI::parse self
  rescue URI::InvalidURIError
    nil
  end

  def url?
    start_with? "http://"
  end

end
