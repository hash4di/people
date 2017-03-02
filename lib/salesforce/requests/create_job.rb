module Salesforce
  module Requests
    class CreateJob < Base
      attr_reader :item, :session

      def initialize(item, session)
        @item = item
        @session = session
        super()
      end

      private

      def url
        "https://#{session[:server_url].host}/services/async/#{API_VERSION}/job"
      end

      def options
        { headers: headers, body: request_body.to_s }
      end

      def headers
        { 'Content-Type' => 'application/xml', 'charset' => 'UTF-8', 'X-SFDC-Session' => session[:token] }
      end

      def initialize_request_body
        super

        update_node xml_arguments('operation', item.operation)
        update_node xml_arguments('object', item.object)
      end
    end
  end
end

