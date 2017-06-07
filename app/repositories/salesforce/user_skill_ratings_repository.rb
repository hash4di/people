module Salesforce
  class UserSkillRatingsRepository < GenericRepository
    def update(item)
      attrs = map_to_salesforce(item)
        .except(:Contact__c, :Skill__c)
        .merge(Id: get_salesforce_id(item))
      salesforce_client.update(salesforce_object_name, attrs).tap do |status|
        raise_sync_failed(item) unless status
      end
    end

    def salesforce_object_name
      'SkillRating__c'
    end

    def map_to_salesforce(rating)
      {
        Contact__c: rating.user.salesforce_id,
        Skill__c: rating.skill.salesforce_id,
        Favorite__c: rating.favorite,
        IDD__c: rating.id,
        Note__c: rating.note,
        Rate__c: rating.rate,
      }
    end
  end
end
