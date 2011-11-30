module FileScheduler
  class Scheduling

    attr_accessor :root, :time

    def initialize(root, time)
      @root = root
      @time = time
    end

    def schedulable_contents
      @schedulable_contents ||= root.contents.select do |content|
        content.time_constraints.nil? or 
          content.time_constraints.matches?(time)
      end
    end

  end
end
