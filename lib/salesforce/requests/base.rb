module Salesforce::Requests
  NodeAbsent = Class.new(StandardError)
  SF = AppConfig.salesforce
  FILE = :provide_file_name

  class Base
    def initialize
      initialize_request_body
      @request_body.to_s
    end

    def initialize_request_body
      @request_body = File.open("./lib/salesforce/files/#{file_name}.xml") do |f|
        Nokogiri::XML(f) { |c| c.noblanks }
      end
    end

    def file_name
      binding.pry
      self.class.name.demodulize.underscore
    end
  end
end
