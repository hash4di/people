module Salesforce
  module Requests
    class AddBatch < Salesforce::Requests::Base
      attr_reader :job, :items, :session

      def initialize(items, session, job)
        @job = job
        @items = items
        @session = session
      end

      private

      def options
        { headers: headers, body: request_body.to_s }
      end

      def url
        "https://#{session[:server_url].host}.salesforce.com/services/async/#{API_VERSION}/job/#{job.id}/batch"
      end

      def headers
        { 'Content-Type' => 'application/json', 'charset' => 'UTF-8' }
      end

      def initialize_request_body
        super

        binding.pry
      end
    end
  end
end
