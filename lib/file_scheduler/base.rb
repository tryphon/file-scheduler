module FileScheduler
  class Base

    attr_accessor :root, :log, :status_file

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
