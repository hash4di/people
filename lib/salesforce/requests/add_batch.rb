module Salesforce
  module Requests
    class AddBatch < Salesforce::Requests::Base
      attr_reader :job_id, :items, :session

      def initialize(items, session, job_id)
        @job_id = job_id
        @items = items
        @session = session
      end

      private

      def options
        { headers: headers, body: request_body.to_s }
      end

      def url
        "https://#{session[:server_url].host}.salesforce.com/services/async/#{API_VERSION}/job/#{job_id}/batch"
      end

      def headers
        { 'Content-Type' => 'application/json', 'charset' => 'UTF-8' }
      end
    end
  end
end
