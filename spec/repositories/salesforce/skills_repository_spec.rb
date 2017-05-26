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
    let(:expected_salesforce_create_attributes) do
      {
        Name: "Debugging",
        Description__c: "Squashing bugs",
        RateType__c: 'range',
        RefName__c: 'backend_debugging',
        CategoryName__c: 'backend',
      }
    end
    let(:expected_salesforce_update_attributes) do
      expected_salesforce_create_attributes
    end
  end
end
