module Salesforce
  class SkillsRepository < GenericRepository
    def salesforce_object_name
      'Skill__c'
    end

    def map_to_salesforce(skill)
      {
        Name: skill.name,
        Description__c: skill.description,
        RateType__c: skill.rate_type,
        RefName__c: skill.ref_name,
        CategoryName__c: skill.skill_category.name,
      }
    end
  end
end
