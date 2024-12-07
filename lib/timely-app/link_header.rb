require "timely-app/record"
require "uri"

module TimelyApp
  module LinkHeader
    extend self

    REGEXP = /<([^>]+)>; rel="(\w+)"/

    def parse(string)
      string.scan(REGEXP).each_with_object(Record.new) do |(uri, rel), record|
        record[rel.to_sym] = URI.parse(uri).request_uri
      end
    end
  end

  private_constant :LinkHeader
end
