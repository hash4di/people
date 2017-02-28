module Salesforce
  module Requests
    class AddBatch < Salesforce::Requests::Base
      attr_reader :job, :items, :session, :response

      def initialize(items, session, job)
        @errors = []
        @job = job
        @items = items
        @session = session
      end

      def send
        Retriable.retriable on: Timeout::Error, tries: 3, base_interval: 1 do
          @response = Nokogiri::XML(request!) { |c| c.noblanks }
        end

        result
      end

      private

      def result
        !errors? && @response.xpath('//jobInfo').present?
      end


      def request!
        HTTParty.post(url, options)
      end

      def options
        { headers: headers, body: request_body.to_s }
      end

      def url
        "https://#{session[:server_url].host}—api.salesforce.com/services/async/#{API_VERSION}/job/#{job.id}/batch"
      end

      def headers
        { 'Content-Type' => 'application/json', 'charset' => 'UTF-8' }
      end

    end
  end
end
