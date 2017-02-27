module Salesforce
  class BulkClient
    attr_reader :session_id, :server_url

    def initialize
      authorize!
    end

    def create_job(item)
      authorize! if session_expired?


    end

    def find_job(item)
      authorize! if session_expired?


    end

    def close_job(item)
      authorize! if session_expired?


    end

    private

    def session_expired?
      @valid_until > Time.zone.now + 5.seconds
    end

    def authorize!
      response = Salesforce::Requests::Auth.new.connect

      @session_id  = response[:session_id]
      @server_url  = response[:server_url]
      @valid_until = response[:valid_until]
    end
  end
end
