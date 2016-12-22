module Salesforce
  class UserSkillRatingsRepository
    SALESFORCE_OBJECT_NAME = 'DeveloperSkillRating__c'.freeze

    SyncFailed = Class.new(StandardError)

    attr_reader :salesforce_client

    def initialize(salesforce_client)
      @salesforce_client = salesforce_client
    end

    def sync(rating)
      if get_salesforce_id(rating)
        update(rating)
      else
        create(rating)
      end
    end

    private

    def create(rating)
      attrs = map_to_salesforce(rating)
      salesforce_client.create(SALESFORCE_OBJECT_NAME, attrs).tap do |salesforce_id|
        raise_sync_failed(rating) unless salesforce_id
        rating.update_column(:salesforce_id, salesforce_id)
      end.present?
    end

    def update(rating)
      attrs = map_to_salesforce(rating).merge(Id: get_salesforce_id(rating))
      salesforce_client.update(SALESFORCE_OBJECT_NAME, attrs).tap do |status|
        raise_sync_failed(rating) unless status
      end
    end

    def raise_sync_failed(rating)
      fail SyncFailed, "couldn't sync UserSkillRating(id=#{ rating.id })"
    end

    def get_salesforce_id(rating)
      rating.salesforce_id
    end

    def map_to_salesforce(rating)
      {
        Developer__c: rating.user.salesforce_id,
        DeveloperSkill__c: rating.skill.salesforce_id,
        Favorite__c: rating.favorite,
        Note__c: rating.note,
        Rating__c: rating.rate,
      }
    end
  end
end
