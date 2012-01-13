module FileScheduler
  class Base

    attr_accessor :root, :log, :status_file

    def initialize(root = nil, attributes = {})
      if Hash === root
        attributes = root
        root = nil
      end

      self.root = root if root

      attributes.each do |k,v|
        send "#{k}=", v
      end
    end

    def root=(root)
      case root
      when String
        if root.url? 
          self.playlist = root
        else
          self.directory = root
        end
      when Pathname
        self.directory = root
      else
        @root = root
      end
    end

    def directory=(directory)
      @root = FileScheduler::File.new directory
    end

    def playlist=(playlist)
      @root = FileScheduler::Playlist.new playlist
    end

    def log
      @log ||= Log.new.tap do |log|
        log.load(status_file) if status_file
      end
    end

    def contents
      root.contents
    end

    def scheduling(time = Time.now)
      Scheduling.new(root, time).tap do |scheduling|
        scheduling.log = log
      end
    end

    def next(time = Time.now)
      scheduling(time).next
    end

    def forced_next(time = Time.now)
      scheduling(time).forced_next
    end

    def after_next(content)
      log.save(status_file) if status_file
    end

    [:next, :forced_next].each do |method|
      alias_method :"#{method}_without_callback", method
      define_method("#{method}_with_callback") do |*arguments|
        content = send "#{method}_without_callback", *arguments
        after_next content
        content
      end
      alias_method method, :"#{method}_with_callback"
    end

  end
end
