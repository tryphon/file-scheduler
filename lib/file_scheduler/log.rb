module FileScheduler
  class Log

    attr_accessor :max_size

    def initialize(options = {})
      options.set_attributes self, :max_size => 100
      @contents = []
    end

    def distance(content)
      @contents.index content
    end

    def log(content)
      @contents.unshift content
      @contents = @contents.first(max_size)
      content
    end

    def load(file)
      @contents = Marshal.load(IO.read(file))
      self
    end

    def save(file)
      File.open(file, "w") do |f|
        f.write Marshal.dump(@contents)
      end
    end

  end
end
