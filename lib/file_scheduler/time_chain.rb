module FileScheduler
  class TimeChain

    attr_reader :parts

    def initialize(*parts)
      @parts = parts.flatten
    end

    def ==(other)
      other.respond_to?(:parts) and parts == other.parts
    end

    def to_s
      parts.join('/')
    end

  end
end
