module FileScheduler
  module Content
    def forced_started_time?
      name.start_with?("T")
    end

    def parser
      @parser ||= TimeParser.new
    end

    def attributes_parser
      @attributes_parser ||= AttributesParser.new
    end

    def repeat_constraints
      @repeat_constraints ||= attributes[:repeat].try(:to_i)
    end
  end
end
