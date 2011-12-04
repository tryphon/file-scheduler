class Time
  alias_method :minute, :min
  alias_method :week_day, :wday

  alias_method :compare_to_without_time_mark_support, :<=>

  def <=>(other)
    if FileScheduler::TimeMark === other
      -(other <=> self)
    else
      compare_to_without_time_mark_support other
    end
  end
end

module FileScheduler
  class TimeMark

    attr_reader :attributes
    
    def initialize(attributes = {})
      @attributes = attributes
    end

    def matches?(time)
      attributes.all? do |attribute, value|
        time.send(attribute) == value
      end
    end

    def [](attribute)
      attributes[attribute]
    end

    [:year, :month, :day, :hour, :minute, :week_day].each do |attribute|
      define_method(attribute) do
        attributes[attribute]
      end
    end

    def <=>(time)
      [:year, :month, :day, :hour, :minute].each do |attribute|
        value = attributes[attribute]
        if value
          comparaison = value <=> time.send(attribute)
          return comparaison unless comparaison == 0
        end
      end

      0
    end

    include Comparable

    def to_s
      [:year, :month, :day, :week_day, :hour, :minute].collect do |attribute|
        value = attributes[attribute]
        if value
          suffix = attribute == :month ? "M" : attribute.to_s.chars.first
          "#{value}#{suffix}"
        end
      end.join
    end

  end
end
