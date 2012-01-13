module FileScheduler
  class Scheduling

    attr_accessor :root, :time, :log

    def initialize(root, time)
      @root = root
      @time = time
    end

    def log
      @log ||= FileScheduler::Log.new
    end

    def schedulable?(content)
      schedulable_by_time?(content) and 
        schedulable_by_repeat?(content)
    end

    def schedulable_by_time?(content)
      content.time_constraints.nil? or
        content.time_constraints.matches?(time)
    end

    def schedulable_by_repeat?(content)
      content.repeat_constraints.nil? or
        log.distance(content).nil? or
        log.distance(content) >= content.repeat_constraints
    end

    def schedulable_contents
      @schedulable_contents ||= root.contents.select do |content|
        schedulable? content
      end
    end

    def forced_contents
      schedulable_contents.select &:forced_started_time?
    end

    def forced_next
      forced_contents.first
    end

    def schedulable_next
      schedulable_contents.sample
    end

    def next_without_log
      forced_next or schedulable_next
    end

    def next_with_log
      log.log(next_without_log)
    end
    alias_method :next, :next_with_log

  end
end
