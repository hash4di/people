module Salesforce
  module Requests
    class CreateJob < Base
      attr_reader :item, :session, :request_body, :errors, :response

      def initialize(item, session)
        @item = item
        @session = session

        super()
      end

      def create
        Retriable.retriable on: Timeout::Error, tries: 3, base_interval: 1 do
          @response = HTTParty.post(url, options)
        end

        @response.code == 201
      end

      private

      def result
        true
      end

      def errors?
        errors.any?
      end

      def url
        @url ||= "https://#{session[:server_url].host}/services/async/#{API_VERSION}/job"
      end

      def options
        { headers: headers, body: request_body.to_s }
      end

      def headers
        { 'Content-Type' => 'application/xml', 'charset' => 'UTF-8', 'X-SFDC-Session' => session[:token] }
      end

      def xml_arguments(field, value)
        {
          field: field,
          value: value,
          shortcut: 'c',
          xmlns: 'http://www.force.com/2009/06/asyncapi/dataload'
        }
      end

      def initialize_request_body
        super

        update_node xml_arguments('operation', item.operation)
        update_node xml_arguments('object', item.object)
      end
    end
  end
end

