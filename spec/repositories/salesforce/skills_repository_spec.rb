require 'spec_helper'

RSpec.describe Salesforce::SkillsRepository do
  let(:repository) { described_class.new(salesforce) }
  let(:salesforce) { double("Salesforce") }

  def make_skill(salesforce_id:)
    double(Skill,
           id: 42,
           name: "Debugging",
           description: "Squashing bugs",
           rate_type: 'range',
           ref_name: 'backend_debugging',
           skill_category: double(name: 'backend'),
           salesforce_id: salesforce_id,
          )
  end

  def set_salesforce_expectation(action, result, attrs)
    expect(salesforce).to receive(action).with("DeveloperSkill__c", attrs).and_return(result)
  end

  let(:attrs) do
    {
      Name: "Debugging",
      Description__c: "Squashing bugs",
      RateType__c: 'range',
      RefName__c: 'backend_debugging',
      CategoryName__c: 'backend',
    }
  end

  context "skill wasn't synced before" do
    let(:skill) { make_skill(salesforce_id: nil) }

    it "creates new entry in Salesforce" do
      set_salesforce_expectation(:create, "sf_id", attrs)
      expect(skill).to receive(:update_column).with(:salesforce_id, "sf_id")
      repository.sync(skill)
    end

    it "raises error if couldn't be created" do
      set_salesforce_expectation(:create, false, attrs)
      expect do
        repository.sync(skill)
      end.to raise_error Salesforce::SkillsRepository::SyncFailed, /id=42/
    end
  end

  context "skill was synced before" do
    let(:skill) { make_skill(salesforce_id: "sf_id") }

    it "updates old entry in Salesforce" do
      set_salesforce_expectation(:update, true, attrs.merge(Id: "sf_id"))
      repository.sync(skill)
    end

    it "raises error if couldn't be updated" do
      set_salesforce_expectation(:update, false, attrs.merge(Id: "sf_id"))
      expect do
        repository.sync(skill)
      end.to raise_error Salesforce::SkillsRepository::SyncFailed, /id=42/
    end
  end
end
