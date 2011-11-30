class Pathname

  def touch(file = nil)
    if file
      (self + file).touch
    else
      FileUtils.touch self
      self
    end
  end
  
  alias_method :mkpath_without_argument, :mkpath

  def mkpath(name = nil)
    if name
      (self+name).mkpath
    else
      mkpath_without_argument
      self
    end
  end

end
