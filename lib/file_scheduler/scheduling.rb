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

    def forced_contents
      schedulable_contents.select(&:forced_started_time?)
    end

    def forced_next
      forced_contents.first
    end

    def schedulable_next
      schedulable_contents.shuffle.first
    end

    def next
      forced_next or schedulable_next
    end

  end
end
