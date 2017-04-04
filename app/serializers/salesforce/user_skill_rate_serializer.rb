module Salesforce
  class UserSkillRateSerializer < ActiveModel::Serializer
    attributes :Contact__c, :Skill__c, :Favorite__c, :Note__c, :Rate__c, :IDD__c

    self.root = false

    def Contact__c
      object.user.salesforce_id
    end

    def Skill__c
      object.skill.salesforce_id
    end

    def Favorite__c
      object.favorite
    end

    def Note__c
      object.note
    end

    def Rate__c
      object.rate
    end

    def IDD__c
      object.id
    end
  end
end
