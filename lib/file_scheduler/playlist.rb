module FileScheduler
  class Playlist

    attr_reader :definition

    def initialize(definition)
      @definition = definition
    end

    def lines
      @lines ||= definition.split
    end

    def contents
      lines.collect do |line|
        FileScheduler::URL.new line
      end
    end

  end
end
