module Salesforce
  module Requests
    class CreateJob
      attr_reader :item, :session, :request_body, :errors

      def initialize(item, session)
        @item = item
        @errors = []
        @session = session
      end

      def create
        Retriable.retriable on: Timeout::Error, tries: 3,
        base_interval: 1 do
          @response = Nokogiri::XML(HTTParty.post(url, options))
        end
        result
      end

      private

      def result
        !errors? && @response.xpath('//jobInfo').present?
      end

      def errors?
        errors.any?
      end

      def url
        @url ||= "https://#{session.server_url.host}/services/async/#{API_VERSION}/job"
      end

      def options
        { headers: headers, body: request_body.to_s }
      end

      def headers
        { 'Content-Type' => 'application/json', 'charset' => 'UTF-8', 'X-SFDC' => session[:token] }
      end

      def initalize_request_body
        super

        update_node('operation', item.operation)
        update_node('object', item.object)
        update_node('contentType', item.content_type)
      end
    end
  end

