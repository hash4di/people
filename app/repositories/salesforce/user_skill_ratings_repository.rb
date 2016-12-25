module Salesforce
  class UserSkillRatingsRepository
    def salesforce_object_name
      'DeveloperSkillRating__c'
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
