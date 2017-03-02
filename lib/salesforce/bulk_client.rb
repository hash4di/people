module Salesforce
  class BulkClient
    AuthorizationError = Class.new(StandardError)

    attr_reader :session, :server

    def initialize
      authorize!
    end

    def create_job(item)
      send_request Salesforce::Requests::CreateJob.new(item, session)
    end

    def close_job(item)
      send_request Salesforce::Requests::CloseJob.new(item, session)
    end

    def add_batch(job, items)
      send_request Salesforce::Requests::AddBatch.new(job, items, session)
    end

    private

    def send_request(request)
      authorize! if session_expired?

      if request.call
        extend_token_validity!
        request.response
      else
        false
      end
    end

    def session_expired?
      session[:valid_until] > Time.zone.now - 3.seconds
    end

    def extend_token_validity!
      session[:valid_until] += 2.hours
    end

    def authorize!
      response = Salesforce::Requests::Auth.new.call

      raise AuthorizationError, "Connection to Salesforce couldn't be established. Investigate request." if response

      credentials = response["Envelope"]["Body"]["loginResponse"]["result"]
      @session = {
        token: credentials["sessionId"],
        server_url: URI.parse(credentials["serverUrl"]),
        valid_until: Time.zone.now + 2.hours
      }
    end
  end
end
