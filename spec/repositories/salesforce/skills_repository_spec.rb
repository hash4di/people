require 'spec_helper'

RSpec.describe Salesforce::SkillsRepository do
  it_behaves_like "generic salesforce repository" do
    let(:local_resource) do
      Skill.new(
        id: 42,
        name: "Debugging",
        description: "Squashing bugs",
        rate_type: 'range',
        ref_name: 'backend_debugging',
        skill_category: SkillCategory.new(name: 'backend'),
      )
    end
    let(:salesforce_resource_name) { "Skill__c" }
    let(:expected_salesforce_attributes) do
      {
        Name: "Debugging",
        Description__c: "Squashing bugs",
        RateType__c: 'range',
        RefName__c: 'backend_debugging',
        CategoryName__c: 'backend',
      }
    end
  end
end
