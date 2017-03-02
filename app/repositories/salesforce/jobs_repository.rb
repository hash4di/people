module Salesforce
  class JobsRepository

    attr_reader :salesforce_client

    def initialize(salesforce_client)
      @salesforce_client = salesforce_client
    end

    def create(item)
      salesforce_client.create_job(item) do |response|
        item.update_attributes(
          state: 'open',
          salesforce_id: response["jobInfo"]["id"]
        )
      end
    end

    def close(item)
      salesforce_client.close_job(item) do |_response|
        item.update_attribute('state', 'closed')
      end
    end

    def add_batch(job, items)
      salesforce_client.add_batch(job, items) do |response|
      end
    end
  end
end
