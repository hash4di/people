module Salesforce
  module Requests
    class CreateJob
      attr_reader :item, :session, :request_body

      def initialize(item, session)
        @item = item
        @session = session
      end

      def create
        begin
          Retriable.retriable on: Timeout::Error, tries: 3,
          base_interval: 1 do
            @response = HTTParty.post(url, options)
          end
        end
      end

      private

      def url
        @url ||= "https://#{session.server_url.host}/services/async/#{API_VERSION}/job"
      end

      def options
        { headers: headers, body: request_body.to_s }
      end

      def headers
        { 'Content-Type' => 'application/json', 'charset' => 'UTF-8', 'X-SFDC' => session[:session_id] }
      end

      def initalize_request_body
        super

        update_node('operation', item.operation)
        update_node('object', item.object)
        update_node('contentType', item.content_type)
      end
    end
  end

