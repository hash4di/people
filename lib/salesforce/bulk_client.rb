module Salesforce
  class BulkClient
    AuthorizationError = Class.new(StandardError)
    SFR = Salesforce::Requests

    attr_reader :session, :server

    def initialize
      authorize!
    end

    def create_job(item)
      authorize! if session_expired?

      if SFR::CreateJob.new(item, session).create
        extend_token_validity!
      end
    end

    def close_job(item)
      authorize! if session_expired?

      if SFR::CloseJob.new(item, session).close
        extend_token_validity!
      end
    end

    private

    def session_expired?
      session[:valid_until] > Time.zone.now - 3.seconds
    end

    def extend_token_validity!
      session[:valid_until] += 2.hours
    end

    def authorize!
      response = SFR::Auth.new.connect

      @session = {
        token: response[:session_id],
        server_url: response[:server_url],
        valid_until: response[:valid_until]
      }

      raise AuthorizationError, "Connection to Salesforce was established, however we couldn't receive data. Investigate request." if session[:token].eql? :not_received
    end
  end
end
