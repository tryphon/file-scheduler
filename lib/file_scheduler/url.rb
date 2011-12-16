module FileScheduler
  class URL
    include FileScheduler::Content

    attr_accessor :path, :url

    def initialize(attributes = {})
      if String === attributes
        attributes = { :path => attributes }
      end

      attributes.each { |k,v| send "#{k}=", v }
    end

    def ==(other)
      other.respond_to?(:path) and path == other.path
    end

    def hidden?
      path_parts.any? do |part|
        part.start_with?("_")
      end
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
      (url and url.to_s) or path 
    end

    def attributes
      @attributes ||= path_parts.inject({}) do |attributes, part|
        attributes.merge attributes_parser.parse(part)
      end
    end

  end
end
