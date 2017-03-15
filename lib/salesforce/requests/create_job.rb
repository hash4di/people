module Salesforce
  module Requests
    class CreateJob < Salesforce::Requests::Base
      attr_reader :sf_object, :operation, :session, :external_id_field_name

      OperationTypeError = Class.new(StandardError)

      # There are more types, but not supported by this code ATM.
      # For more details please check JobInfo on Salesforce Bulk API.
      OPERATION_TYPES = %w(insert upsert delete).freeze

      def initialize(session, operation:, sf_object:, external_id_field_name: 'none')
        @operation = operation
        @sf_object = sf_object
        @external_id_field_name = external_id_field_name
        @session = session
        check_operation_type
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
        { 'Content-Type' => 'application/xml', 'charset' => 'UTF-8', 'X-SFDC-Session' => session.fetch(:token) }
      end

      def initialize_request_body
        super
        update_node xml_arguments('operation', operation)
        update_node xml_arguments('object', sf_object)
        add_external_field_on_upsert
      end

      def add_external_field_on_upsert
        return unless operation.eql? 'upsert'

        request_body.root.children[1].add_next_sibling "<externalIdFieldName>#{external_id_field_name}</externalIdFieldName>"
      end

      def check_operation_type
        error_msg = "Operation=#{operation} is not supported."
        raise OperationTypeError, error_msg unless OPERATION_TYPES.include? operation
      end
    end
  end
end

