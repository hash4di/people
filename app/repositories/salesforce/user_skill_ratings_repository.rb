module Salesforce
  class UserSkillRatingsRepository < GenericRepository
    def salesforce_object_name
      'ContactSkillRating__c'
    end

    def map_to_salesforce(rating)
      {
        Contact__c: rating.user.salesforce_id,
        ContactSkill__c: rating.skill.salesforce_id,
        Favorite__c: rating.favorite,
        Note__c: rating.note,
        Rate__c: rating.rate,
      }
    end
  end
end
