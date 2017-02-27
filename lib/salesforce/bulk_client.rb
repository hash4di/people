module Salesforce
  class BulkClient
    attr_reader :session_id, :server_url

    def initialize
      authorize!
    end

    def create_job(item)
    end

    def find_job(item)
    end

    def close_job(item)
    end

    private

    def authorize!
      puts "authorized"
      # @session_id, @server_url = Salesforce::Requests::Auth.new.connect
    end
  end
end
