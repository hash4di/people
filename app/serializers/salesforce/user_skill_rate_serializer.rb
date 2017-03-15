module Salesforce
  class UserSkillRateSerializer < ActiveModel::Serializer
    attributes :Contact__c, :DeveloperSkill__c, :Favorite__c, :Note__c, :Rating__c

    self.root = false

    def Contact__c
      object.user.salesforce_id
    end

    def DeveloperSkill__c
      object.skill.salesforce_id
    end

    def Favorite__c
      object.favorite
    end

    def Note__c
      object.note
    end

    def Rating__c
      object.rate
    end
  end
end
