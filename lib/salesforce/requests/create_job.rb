module Salesforce
  module Requests
    class CreateJob
      base_uri 'test.salesforce.com:443'

      attr_reader :item, :session

      def initialize(item, session)
        @item = item
        @session = session
        super
      end

      def create
        begin
          Retriable.retriable on: Timeout::Error, tries: 3,
          base_interval: 1 do
            response = self.class.post("/services/async/#{API_VERSION}/job")
          end
        end
      end

      private

      def options
        { headers: headers, body: request_body.to_s }
      end

      def headers
        { 'Content-Type' => 'application/json', 'charset' => 'UTF-8', 'X-SFDC'}
      end

      def initalize_request_body
        super

        update_node('operation', item.operation)
        update_node('object', item.object)
        update_node('contentType', item.content_type)
      end
    end
  end

