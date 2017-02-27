module Salesforce
  class JobsRepository
    attr_reader :salesforce_client

    def initialize(salesforce_client)
      @salesforce_client = salesforce_client
    end

    def create(item)
      salesforce_client.create(item)
    end

    def find(item)
      salesforce_client.fetch_job(item)
    end
  end
end
