module Salesforce
  class JobsRepository
    attr_reader :salesforce_client

    def initialize(salesforce_client)
      @salesforce_client = salesforce_client
    end

    def create(item)
      salesforce_client.create_job(item) do |response|
        item.update_attributes(
          status: 'open',
          salesforce_id: response[:id]
        )
      end
    end

    def close(item)
      if salesforce_client.close_job(item) do |_response|
        item.update_attribute('state', 'closed')
      end
    end
  end
end
