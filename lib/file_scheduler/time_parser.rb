module FileScheduler
  class TimeParser

    @@time_mark_fields =
      [["y", 4], ["M", 2], ["d", 2], ["w", 1], ["h", 2], ["m", 2]]

    def self.time_mark_format
      @@time_mark_fields.collect do |field|
        "(\\d{#{field[1]}}#{field[0]})?"
      end.join
    end

    def parse(string)
      parsed_fields = string.scan(/^T?#{self.class.time_mark_format}(-#{self.class.time_mark_format})?/).first.map do |field|
        field.to_i if field
      end

      from = time_mark(parsed_fields.first(6))
      to = time_mark(parsed_fields.last(6))

      if to
        TimeInterval.new from, to
      else
        from
      end
    end

    def time_mark(parsed_fields)
      unless parsed_fields.all?(&:nil?)
        attributes = Hash[ [[:year, :month, :day, :week_day, :hour, :minute], parsed_fields].transpose ]
        attributes.delete_if { |k,v| v.nil? }
        TimeMark.new attributes
      end
    end

  end
end
