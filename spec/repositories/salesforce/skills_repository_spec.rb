require 'spec_helper'

RSpec.describe Salesforce::SkillsRepository do
  let(:repository) { described_class.new(salesforce) }
  let(:salesforce) { double("Salesforce") }

  def make_skill(salesforce_id:)
    double(Skill, id: 42, name: 'Ruby on Rails', salesforce_id: salesforce_id)
  end

  def set_salesforce_expectation(action, result, attrs)
    expect(salesforce)
      .to receive(action)
      .with('DeveloperSkill__c', attrs)
      .and_return(result)
  end

  context "skill wasn't synced before" do
    let(:skill) { make_skill(salesforce_id: nil) }

    it 'creates new entry in Salesforce' do
      set_salesforce_expectation(:create, 'sf_id', Name: 'Ruby on Rails')
      expect(skill).to receive(:update).with(salesforce_id: 'sf_id')
      repository.sync(skill)
    end

    it 'raises error if couldn\'t be created' do
      set_salesforce_expectation(:create, false, Name: 'Ruby on Rails')
      expect { repository.sync(skill) }.to raise_error Salesforce::SkillsRepository::SyncFailed, /id=42/
    end
  end

  context 'skill was synced before' do
    let(:skill) { make_skill(salesforce_id: 'sf_id') }

    it 'updates entry in Salesforce' do
      set_salesforce_expectation(:update, true, Name: 'Ruby on Rails', Id: 'sf_id')
      repository.sync(skill)
    end

    it 'raises error on failed update' do
      set_salesforce_expectation(:update, false, Id: 'sf_id', Name: 'Ruby on Rails')
      expect { repository.sync(skill) }.to raise_error Salesforce::SkillsRepository::SyncFailed, /id=42/
    end
  end
end
