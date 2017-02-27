module Salesforce::Requests
  NodeAbsent = Class.new(StandardError)

  SF = AppConfig.salesforce
  FILE = :provide_file_name
  API_VERSION = '38.0'.freeze

  class Base
    attr_reader :request_body
    include HTTParty

    def initialize
      initialize_request_body
      self
    end

    def initialize_request_body
      @request_body = File.open("./lib/salesforce/files/#{file_name}.xml") do |f|
        Nokogiri::XML(f) { |c| c.noblanks }
      end
    end

    def file_name
      self.class.name.demodulize.underscore
    end

    private

    def update_node(field, value)
      nodes = @request_body.xpath("//#{field}")
      raise NodeAbsent, "Node=#{field} couldn't be found in xml file." if nodes.empty?

      nodes[0].content = value
    end
  end
end
