require 'spec_helper'

RSpec.describe Salesforce::UsersRepository do
  let(:repository) { described_class.new(salesforce) }
  let(:salesforce) { double("Salesforce") }

  def make_user(salesforce_id:)
    double(User,
           id: 42,
           first_name: 'John',
           last_name: 'Smith',
           salesforce_id: salesforce_id
          )
  end

  def set_salesforce_expectation(action, result, attrs)
    expect(salesforce)
      .to receive(action)
      .with('Developer__c', attrs)
      .and_return(result)
  end

  context "user wasn't synced before" do
    let(:user) { make_user(salesforce_id: nil) }

    it 'creates new entry in Salesforce' do
      set_salesforce_expectation(:create, 'sf_id', Name: 'John Smith')
      expect(user).to receive(:update).with(salesforce_id: 'sf_id')
      repository.sync(user)
    end

    it 'raises error if couldn\'t be created' do
      set_salesforce_expectation(:create, false, Name: 'John Smith')
      expect { repository.sync(user) }.to raise_error Salesforce::UsersRepository::SyncFailed, /id=42/
    end
  end

  context 'user was synced before' do
    let(:user) { make_user(salesforce_id: 'sf_id') }

    it 'updates entry in Salesforce' do
      set_salesforce_expectation(:update, true, Name: 'John Smith', Id: 'sf_id')
      repository.sync(user)
    end

    it 'raises error on failed update' do
      set_salesforce_expectation(:update, false, Id: 'sf_id', Name: 'John Smith')
      expect { repository.sync(user) }.to raise_error Salesforce::UsersRepository::SyncFailed, /id=42/
    end
  end
end
