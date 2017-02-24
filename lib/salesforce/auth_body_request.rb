module Salesforce
  NodeAbsent = Class.new(StandardError)

  class AuthBodyRequest
    def initialize
      initialize_request_body
    end

    def body
      @request_body.to_s
    end

    private

    def initialize_request_body
      @request_body = File.open('./lib/salesforce/files/auth.xml') do |f|
        Nokogiri::XML(f) { |c| c.noblanks }
      end

      sf = AppConfig.salesforce

      update_node('username', sf.username)
      update_node('password', sf.password + sf.security_token)
    end

    def update_node(field, value)
      nodes = @request_body.xpath("//n1:#{field}", n1: 'urn:partner.soap.sforce.com')
      raise NodeAbsent, "Node=#{field} couldn't be found in xml file." if nodes.empty?

      nodes[0].content = value
    end
  end
end
