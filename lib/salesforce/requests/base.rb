module Salesforce::Requests
  NodeAbsent = Class.new(StandardError)

  SF = AppConfig.salesforce
  FILE = :provide_file_name
  API_VERSION = '38.0'.freeze

  class Base
    attr_reader :request_body, :response

    def initialize
      initialize_request_body
    end

    def call
      Retriable.retriable on: Timeout::Error, tries: 3, base_interval: 1 do
        @response = HTTParty.post(url, options)
      end

      success?
    end

    private

    def url
      ""
    end

    def headers
     {}
    end

    def options
      { headers: {}, body: :none }
    end

    def success?
      response.code.between?(200, 299)
    end

    def initialize_request_body
      @request_body = File.open("./lib/salesforce/files/#{file_name}.xml") do |f|
        Nokogiri::XML(f, &:noblanks)
      end
    end

    def file_name
      self.class.name.demodulize.underscore
    end

    def xml_arguments(field, value)
      {
        field: field,
        value: value,
        namespace: 'c',
        xmlns: 'http://www.force.com/2009/06/asyncapi/dataload'
      }
    end

    def update_node(field:, value:, namespace:, xmlns:)
      nodes = @request_body.xpath("//#{namespace}:#{field}", { namespace => xmlns })
      raise NodeAbsent, "Node=#{field} couldn't be found in xml file." if nodes.empty?

      nodes[0].content = value
    end
  end
end
