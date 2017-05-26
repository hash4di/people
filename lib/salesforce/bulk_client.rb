module Salesforce
  class BulkClient
    AuthorizationError = Class.new(StandardError)

    attr_reader :session, :server, :last_response

    def initialize
      authorize!
    end

    def create_job(params)
      send_request Salesforce::Requests::CreateJob.new(session, params)
    end

    def close_job(job_id)
      send_request Salesforce::Requests::CloseJob.new(job_id, session)
    end

    def add_batch(job_id, items)
      send_request Salesforce::Requests::AddBatch.new(job_id, items, session)
    end

    private

    def send_request(request)
      authorize! if session_expired?
      success = request.call
      @last_response = request.response

      if success
        extend_token_validity!
        last_response
      else
        false
      end
    end

    def session_expired?
      session[:valid_until] > Time.zone.now - 1.minute
    end

    def extend_token_validity!
      session[:valid_until] = Time.zone.now + 2.hours
    end

    def authorize!
      auth_request = Salesforce::Requests::Auth.new
      raise AuthorizationError, "Connection to Salesforce couldn't be established. Investigate request." unless auth_request.call

      credentials = auth_request.response['Envelope']['Body']['loginResponse']['result']
      @session = {
        token: credentials['sessionId'],
        server_url: URI.parse(credentials['serverUrl']),
        valid_until: Time.zone.now + 2.hours
      }
    end
  end
end
