module FileScheduler
  class Base

    attr_accessor :root

    def initialize(root)
      @root = FileScheduler::File.new(root)
    end

    def contents
      root.contents
    end

    def next(time = Time.now)
      Scheduling.new(root, time).schedulable_contents.shuffle.first
    end

  end
end
