require 'set'

module FileScheduler
  class TimeInterval

    attr_reader :from, :to
    
    def initialize(from, to)
      @from, @to = from, to
    end

    def include?(time)
      if from > to
        not time.between?(to, from)
      else
        time.between?(from, to)
      end
    end

    alias_method :matches?, :include?

    def ==(other)
      [:from, :to].all? do |attribute|
        other.respond_to?(attribute) and send(attribute) == other.send(attribute)
      end
    end

    def to_s
      "#{from}-#{to}"
    end

    def inspect
      to_s
    end

  end

end
