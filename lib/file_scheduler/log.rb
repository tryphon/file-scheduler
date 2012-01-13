module FileScheduler
  class Log

    attr_accessor :max_size

    def initialize(options = {})
      options.set_attributes self, :max_size => 100
      clear
    end

    def distance(content)
      @contents.index content.to_s
    end

    def log(content)
      @contents.unshift content.to_s
      @contents = @contents.first(max_size)
      content
    end

    def clear
      @contents = []
    end

    def empty?
      @contents.empty?
    end

    include Enumerable
    def each(&block)
      @contents.each(&block)
    end

    def load(data)
      return unless data

      # Marshalled data starts with \004
      unless data.start_with?("\004")
        if ::File.exists?(data)
          data = IO.read(data)
        else
          data = nil
        end
      end

      if data
        @contents = Marshal.load data
      else
        @contents = []
      end

      self
    end

    def dump
      Marshal.dump(@contents)
    end

    def save(file)
      ::File.open(file, "w") do |f|
        f.write dump
      end
    end

    def ==(other)
      other and @contents == other.to_a
    end

  end
end
