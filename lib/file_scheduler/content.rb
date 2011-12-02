module FileScheduler
  module Content
    def forced_started_time?
      name.start_with?("T")
    end

    def parser
      @parser ||= TimeParser.new
    end
  end
end
