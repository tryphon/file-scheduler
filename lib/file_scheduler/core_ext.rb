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

class Object

  def try(method, *arguments)
    send method, *arguments
  end

end

class Nil

  def try(method, *arguments)
    nil
  end

end

class Hash

  def set_attributes(object, defaults = {})
    defaults.merge(self).each { |k,v| object.send "#{k}=", v }
  end

end

class Array
  def sample
    self[rand(self.size)]
  end
end
