module Salesforce::Requests
  class CloseJob < Salesforce::Requests::Base
    attr_reader :job_id, :session

    def initialize(job_id, session)
      @job_id = job_id
      @session = session

      super()
    end

    private

    def url
      "https://#{session.fetch(:server_url).host}/services/async/#{API_VERSION}/job/#{job_id}"
    end

    def options
      { headers: headers, body: request_body.to_s }
    end

    def headers
      {
        'Content-Type' => 'application/xml',
        'charset' => 'UTF-8',
        'X-SFDC-Session' => session.fetch(:token)
      }
    end
  end
end
