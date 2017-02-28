module Salesforce::Requests
  class CloseJob < Salesforce::Requests::Base
    attr_reader :item, :session, :request_body, :errors

    def initailize(item, session)
      @errors = []
      @item = item
      @session = session
    end

    def close
      Retriable.retriable on: Timeout::Error, tries: 3, base_interval: 1 do
        @response = Nokogiri::XML(HTTparty.post(url, options))
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
      @url ||= "https://#{session.server_url.host}/services/async/#{API_VERSION}/job/#{item.salesforce_id}"
    end

    def options
      { headers: headers, body: request_body.to_s }
    end

    def headers
      { 'Content-Type' => 'application/json', 'charset' => 'UTF-8', 'X-SFDC' => session[:token] }
    end
  end
end
