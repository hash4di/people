module Salesforce
  class SkillsRepository
    SALESFORCE_OBJECT_NAME = 'DeveloperSkill__c'.freeze

    SyncFailed = Class.new(StandardError)

    attr_reader :salesforce_client

    def initialize(salesforce_client)
      @salesforce_client = salesforce_client
    end

    def sync(skill)
      if get_salesforce_id(skill)
        update(skill)
      else
        create(skill)
      end
    end

    private

    def create(skill)
      attrs = map_to_salesforce(skill)
      salesforce_client.create(SALESFORCE_OBJECT_NAME, attrs).tap do |salesforce_id|
        raise_sync_failed(skill) unless salesforce_id
        skill.update(salesforce_id: salesforce_id)
      end.present?
    end

    def update(skill)
      attrs = map_to_salesforce(skill).merge(Id: get_salesforce_id(skill))
      salesforce_client.update(SALESFORCE_OBJECT_NAME, attrs).tap do |status|
        raise_sync_failed(skill) unless status
      end
    end

    def raise_sync_failed(skill)
      fail SyncFailed, "couldn't sync Skill(id=#{ skill.id })"
    end

    def get_salesforce_id(skill)
      skill.salesforce_id
    end

    def map_to_salesforce(skill)
      {
        Name: skill.name,
        Description__c: skill.description,
      }
    end
  end
end
