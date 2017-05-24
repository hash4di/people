require 'spec_helper'

RSpec.describe Salesforce::UserSkillRatingsRepository do
  it_behaves_like "generic salesforce repository" do
    let(:local_resource) do
      UserSkillRate.new(
        id: 42,
        user: User.new(salesforce_id: "foo"),
        skill: Skill.new(salesforce_id: "bar"),
        favorite: false,
        note: "A few words",
        rate: 4,
      )
    end
    let(:salesforce_resource_name) { "SkillRating__c" }
    let(:expected_salesforce_create_attributes) do
      {
        Contact__c: "foo",
        Skill__c: "bar",
        Favorite__c: false,
        Note__c: "A few words",
        Rate__c: 4,
      }
    end
    let(:expected_salesforce_update_attributes) do
      {
        Favorite__c: false,
        Note__c: "A few words",
        Rate__c: 4,
      }
    end
  end
end
