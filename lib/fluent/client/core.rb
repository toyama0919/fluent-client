module Fluent
  module Client
    class Core
      def initialize
      end

      def create_parser(format, time_format, keys)
        if format == 'multiline'
          STDERR.puts 'multiline format is not support!'
          exit 1
        end

        if format[0] == '/' && format[format.length - 1] == '/'
          format = format.gsub(/^\/(.+)\/$/, '\1')
          parser = Fluent::TextParser::RegexpParser.new(Regexp.new(format))
        else
          factory = Fluent::TextParser::TEMPLATE_REGISTRY.lookup(format)
          parser = factory.call
        end
        parser.configure('time_format' => time_format) unless time_format.nil?
        parser.configure('keys' => keys) unless keys.nil?
        parser
      end

      def parse_text(format, time_format, keys, buffer = STDIN.read)
        results = []
        parser = create_parser(format, time_format, keys)
        begin
          buffer.lines.each_with_index do |line, i|
            line = line.strip
            parsed_time, parsed = parser.call(line)
            if parsed.nil?
              puts "format error! line #{i + 1} [#{line}]"
            else
              puts parsed
            end
            results << parsed unless parsed.nil?
          end
        rescue ArgumentError, RegexpError => e
          STDERR.puts "\n#{e.message}\n#{e.backtrace.join("\n")}"
          parsed_time = parsed = nil
        end
        results
      end
    end
  end
end
