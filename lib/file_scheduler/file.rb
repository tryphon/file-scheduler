module FileScheduler
  class File

    attr_accessor :path, :parent

    def initialize(path, parent = nil)
      @parent = parent
      @path = Pathname.new(path)
    end

    def name
      @name ||= path.basename.to_s
    end

    def hidden?
      name.start_with?("_")
    end

    def local_time_constraints
      parser.parse(name) if parent
    end

    def time_constraints
      @time_constraints ||= 
        if parent and parent.time_constraints
          if local_time_constraints
            TimeChain.new parent.time_constraints, local_time_constraints
          else
            parent.time_constraints
          end
        else
          local_time_constraints
        end
    end

    def file_system_children
      @file_system_children ||= path.children
    end

    include FileScheduler::Content

    def children
      @children ||= file_system_children.collect do |file|
        File.new(file, self)
      end.delete_if(&:hidden?)
    end

    def contents
      if content?
        [self]
      else
        children.collect(&:contents).flatten
      end
    end

    def content?
      path.file?
    end

    def ==(other)
      [:parent, :path].all? do |attribute|
        other.respond_to?(attribute) and send(attribute) == other.send(attribute)
      end
    end

    def to_s
      path.to_s
    end

  end
end
