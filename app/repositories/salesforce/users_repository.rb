module Salesforce
  class UsersRepository
    SALESFORCE_OBJECT_NAME = 'Developer__c'.freeze

    SyncFailed = Class.new(StandardError)

    attr_reader :salesforce_client

    def initialize(salesforce_client)
      @salesforce_client = salesforce_client
    end

    def sync(user)
      if get_salesforce_id(user)
        update(user)
      else
        create(user)
      end
    end

    private

    def update(user)
      attrs = map_to_salesforce(user).merge(Id: get_salesforce_id(user))
      salesforce_client.update(SALESFORCE_OBJECT_NAME, attrs).tap do |status|
        raise_sync_failed(user) unless status
      end
    end

    def create(user)
      attrs = map_to_salesforce(user)
      salesforce_client.create(SALESFORCE_OBJECT_NAME, attrs).tap do |salesforce_id|
        raise_sync_failed(user) unless salesforce_id
        user.update(salesforce_id: salesforce_id)
      end.present?
    end

    def raise_sync_failed(user)
      fail SyncFailed, "couldn't sync User(id=#{user.id})"
    end

    def get_salesforce_id(user)
      user.salesforce_id
    end

    def map_to_salesforce(user)
      {
        Name: [user.first_name, user.last_name].join(' ')
      }
    end
  end
end
