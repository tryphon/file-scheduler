module FileScheduler
  class Base

    attr_accessor :root

    def initialize(attributes = {})
      @root =
        if String === attributes or Pathname === attributes
          FileScheduler::File.new(attributes)
        elsif attributes.has_key?(:playlist)
          FileScheduler::Playlist.new(attributes[:playlist])
        end
    end

    def contents
      root.contents
    end

    def next(time = Time.now)
      Scheduling.new(root, time).next
    end

  end
end
