require 'time'

class Numeric

  def minutes
    self * 60
  end

end

class Time
  def attributes(*only)
    %w{year month day hour minute week_day}.inject({}) do |attributes, name|
      name = name.to_sym
      attributes[name] = send(name) if only.empty? or only.include?(name)
      attributes
    end
  end
end
