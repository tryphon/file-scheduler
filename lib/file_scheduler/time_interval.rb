require 'set'

module FileScheduler
  class TimeInterval

    attr_reader :from, :to
    
    def initialize(from, to)
      @from, @to = from, to
    end

    def include?(time)
      from.compare_to(time, reversed_attributes) <= 0 and
        to.compare_to(time) > 0
    end

    alias_method :matches?, :include?

    def reversed_attributes
      @reversed_attributes ||= common_attributes.select do |attribute|
        from[attribute] > to[attribute]
      end
    end

    def common_attributes
      from.attributes.keys & to.attributes.keys
    end

    def ==(other)
      [:from, :to].all? do |attribute|
        other.respond_to?(attribute) and send(attribute) == other.send(attribute)
      end
    end

    def to_s
      "#{from}-#{to}"
    end

  end

end
