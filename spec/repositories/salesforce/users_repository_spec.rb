require 'spec_helper'

RSpec.describe Salesforce::UsersRepository do
  let(:repository) { described_class.new(salesforce) }
  let(:salesforce) { double("Salesforce") }

  def make_user(salesforce_id:)
    double(User,
           id: 42,
           first_name: "John",
           last_name: "Doe",
           salesforce_id: salesforce_id,
          )
  end

  def set_salesforce_expectation(action, result, attrs)
    expect(salesforce).to receive(action).with("Developer__c", attrs).and_return(result)
  end

  context "user wasn't synced before" do
    let(:user) { make_user(salesforce_id: nil) }

    it "creates new entry in Salesforce" do
      set_salesforce_expectation(:create, "sf_id", Name: "John Doe")
      expect(user).to receive(:update).with(salesforce_id: "sf_id")
      repository.sync(user)
    end

    it "raises error if couldn't be created" do
      set_salesforce_expectation(:create, false, Name: "John Doe")
      expect do
        repository.sync(user)
      end.to raise_error Salesforce::UsersRepository::SyncFailed, /id=42/
    end
  end

  context "user was synced before" do
    let(:user) { make_user(salesforce_id: "sf_id") }

    it "updates old entry in Salesforce" do
      set_salesforce_expectation(:update, true, Id: "sf_id", Name: "John Doe")
      repository.sync(user)
    end

    it "raises error if couldn't be updated" do
      set_salesforce_expectation(:update, false, Id: "sf_id", Name: "John Doe")
      expect do
        repository.sync(user)
      end.to raise_error Salesforce::UsersRepository::SyncFailed, /id=42/
    end
  end
end
