module Salesforce
  class BulkClient
    AuthorizationError = Class.new(StandardError)

    attr_reader :session, :server

    def initialize
      authorize!
    end

    def create_job(item)
      authorize! if session_expired?
      request = Salesforce::Requests::CreateJob.new(item, session)

      if request.create
        extend_token_validity!
        yield(request.response)
      end
    end

    def close_job(item)
      authorize! if session_expired?
      request = Salesforce::Requests::CloseJob.new(item, session)

      if request.close
        extend_token_validity!
        yield(request.response)
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
      response = Salesforce::Requests::Auth.new.connect

      @session = {
        token: response[:session_id],
        server_url: response[:server_url],
        valid_until: response[:valid_until]
      }

      raise AuthorizationError, "Connection to Salesforce was established, however we couldn't receive data. Investigate request." if session[:token].eql? :not_received
    end
  end
end
