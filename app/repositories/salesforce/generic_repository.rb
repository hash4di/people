module Salesforce
  class GenericRepository
    SyncFailed = Class.new(StandardError)

    attr_reader :salesforce_client

    def initialize(salesforce_client)
      @salesforce_client = salesforce_client
    end

    def sync(item)
      if get_salesforce_id(item)
        update(item)
      else
        create(item)
      end
    end

    private

    def create(item)
      attrs = map_to_salesforce(item)
      salesforce_client.create(salesforce_object_name, attrs).tap do |salesforce_id|
        raise_sync_failed(item) unless salesforce_id
        item.update_column(:salesforce_id, salesforce_id)
      end.present?
    end

    def update(item)
      attrs = map_to_salesforce(item).merge(Id: get_salesforce_id(item))
      salesforce_client.update(salesforce_object_name, attrs).tap do |status|
        raise_sync_failed(item) unless status
      end
    end

    def raise_sync_failed(item)
      fail SyncFailed, "couldn't sync #{ item.class.name }(id=#{ item.id })"
    end

    def get_salesforce_id(item)
      item.salesforce_id
    end

    def map_to_salesforce(_item)
      fail "you must override this method in a child class"
    end

    def salesforce_object_name
      fail "you must override this method in a child class"
    end
  end
end
