class Time
  alias_method :minute, :min
  alias_method :week_day, :wday
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

    def compare_to(time, reversed = [])
      [:year, :month, :day, :hour, :minute].each do |attribute|
        value = attributes[attribute]
        if value
          comparaison = value <=> time.send(attribute)
          comparaison = - comparaison if reversed.include?(attribute)
          return comparaison unless comparaison == 0
        end
      end

      0
    end

    alias_method :<=>, :compare_to
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
