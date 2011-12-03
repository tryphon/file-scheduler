module FileScheduler
  class Base

    attr_accessor :root

    def initialize(attributes = {})
      case attributes
      when String
        attributes = 
          { (attributes.url? ? :playlist : :directory) => attributes }
      when Pathname
        attributes = { :directory => attributes }
      end

      @root =
        if attributes.has_key?(:directory)
          FileScheduler::File.new(attributes[:directory])
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

    def forced_next(time = Time.now)
      Scheduling.new(root, time).forced_next
    end

  end
end
