module Salesforce
  module Requests
    class Auth < Salesforce::Requests::Base
      base_uri SF.soap_login

      def connect
        self.class.post("services/Soap/u/#{API_VERSION}", options)
      end

      private

      def options
        { headers: headers, body: request_body.to_s }
      end

      def headers
        { 'SOAPAction' => 'login', 'Content-Type' => 'text/xml' }
      end

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
end
