module Salesforce
  module Requests
    class Auth < Salesforce::Requests::Base
      base_uri 'test.salesforce.com:443'

      def connect
        begin
          Retriable.retriable on: Timeout::Error, tries: 3, base_interval: 1 do
            response = self.class.post("/services/Soap/u/#{API_VERSION}", options)
            @response = response["Envelope"]["Body"]["loginResponse"]["result"]
          end
        rescue NoMethodError, TypeError
          @response['serverUrl'] = :not_received
          @response['sessionId'] = :not_received
        end

        {
          server_url: URI.parse(@response['serverUrl']),
          session_id: @response['sessionId'],
          valid_until: Time.zone.now + 2.hours
        }
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

        update_node xml_arguments('username', SF.username)
        update_node xml_arguments('password', SF.password + SF.security_token)
      end

      def xml_arguments(field, value)
        {
          field: field,
          value: value,
          shortcut: 'n1',
          xmlns: 'urn:partner.soap.sforce.com'
        }
      end
    end
  end
end
