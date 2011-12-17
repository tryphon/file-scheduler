module FileScheduler
  class Log

    attr_accessor :max_size

    def initialize(options = {})
      options.set_attributes self, :max_size => 100
      clear
    end

    def distance(content)
      @contents.index content
    end

    def log(content)
      @contents.unshift content
      @contents = @contents.first(max_size)
      content
    end

    def clear
      @contents = []
    end

    include Enumerable
    def each(&block)
      @contents.each(&block)
    end

    def load(data)
      return unless data

      # Marshalled data starts with \004
      unless data.start_with?("\004")
        data = IO.read(file) if File.exists?(data)
      end

      @contents = Marshal.load data
      self
    end

    def dump
      Marshal.dump(@contents)
    end

    def save(file)
      File.open(file, "w") do |f|
        f.write dump
      end
    end

  end
end
