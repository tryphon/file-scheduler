module FileScheduler
  class AttributesParser

    def parse(string)
      Parsing.new(string).attributes
    end

    class Parsing

      attr_reader :string

      def initialize(string)
        @string = string
      end

      def definition
        # Matches {...}$ or {...}.ext$
        if string =~ /\{([^\}]+)\}($|\.[^.]+$)/
          $1
        else
          ""
        end
      end

      def pairs
        definition.split(",")
      end

      def attributes
        pairs.inject({}) do |attributes, pair|
          key, value = pair.split("=")
          attributes[key.strip.to_sym] = value.strip
          attributes
        end
      end

    end

  end
end
