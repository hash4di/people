module Salesforce
  module Requests
    class Auth < Salesforce::Requests::Base

        {
          server_url: URI.parse(@response['serverUrl']),
          session_id: @response['sessionId'],
          valid_until: Time.zone.now + 2.hours
        }

      end

      private

      def url
        "https://test.salesforce.com/services/Soap/u/#{}"
      end

      def options
        { headers: headers, body: request_body.to_s }
      end

      def headers
        { 'SOAPAction' => 'login', 'Content-Type' => 'text/xml' }
      end

      def initialize_request_body
        super

        update_node xml_arguments('username', SF.username)
        update_node xml_arguments('password', SF.password + SF.security_token)
      end

      def xml_arguments(field, value)
        {
          field: field,
          value: value,
          namespace: 'n1',
          xmlns: 'urn:partner.soap.sforce.com'
        }
      end
    end
  end
end
