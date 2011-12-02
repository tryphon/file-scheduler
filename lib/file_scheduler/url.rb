module FileScheduler
  class URL
    include FileScheduler::Content

    attr_reader :path

    def initialize(path)
      @path = path
    end

    def ==(other)
      other.respond_to?(:path) and path == other.path
    end

    def path_parts
      @path_parts ||= path.split("/")
    end

    def name
      @path_parts.last
    end

    def time_constraints
      part_constraints = path_parts.collect do |part|
        parser.parse(part)
      end.compact

      if part_constraints.size > 1
        FileScheduler::TimeChain.new part_constraints
      else
        part_constraints.first
      end
    end
    
    def to_s
      path
    end

  end
end
