module Salesforce::Requests
  class Auth < Salesforce::Requests::Base
    private

    def initialize_request_body
      super

      update_node('username', SF.username)
      update_node('password', SF.password + SF.security_token)
    end

    def update_node(field, value)
      nodes = @request_body.xpath("//n1:#{field}", n1: 'urn:partner.soap.sforce.com')
      raise NodeAbsent, "Node=#{field} couldn't be found in xml file." if nodes.empty?

      nodes[0].content = value
    end
  end
end
