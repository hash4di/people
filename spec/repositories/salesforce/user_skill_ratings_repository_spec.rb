require 'spec_helper'

RSpec.describe Salesforce::UserSkillRatingsRepository do
  let(:repository) { described_class.new(salesforce) }
  let(:salesforce) { double("Salesforce") }

  def make_rating(salesforce_id:)
    double(UserSkillRate,
           id: 42,
           user: double(salesforce_id: "foo"),
           skill: double(salesforce_id: "bar"),
           favorite: false,
           note: "A few words",
           rate: 4,
           salesforce_id: salesforce_id,
          )
  end

  def set_salesforce_expectation(action, result, attrs)
    expect(salesforce).to receive(action).with("DeveloperSkillRating__c", attrs).and_return(result)
  end

  let(:attrs) do
    {
      Developer__c: "foo",
      DeveloperSkill__c: "bar",
      Favorite__c: false,
      Note__c: "A few words",
      Rating__c: 4,
    }
  end

  context "rating wasn't synced before" do
    let(:rating) { make_rating(salesforce_id: nil) }

    it "creates new entry in Salesforce" do
      set_salesforce_expectation(:create, "sf_id", attrs)
      expect(rating).to receive(:update_column).with(:salesforce_id, "sf_id")
      repository.sync(rating)
    end

    it "raises error if couldn't be created" do
      set_salesforce_expectation(:create, false, attrs)
      expect do
        repository.sync(rating)
      end.to raise_error Salesforce::UserSkillRatingsRepository::SyncFailed, /id=42/
    end
  end

  context "rating was synced before" do
    let(:rating) { make_rating(salesforce_id: "sf_id") }

    it "updates old entry in Salesforce" do
      set_salesforce_expectation(:update, true, attrs.merge(Id: "sf_id"))
      repository.sync(rating)
    end

    it "raises error if couldn't be updated" do
      set_salesforce_expectation(:update, false, attrs.merge(Id: "sf_id"))
      expect do
        repository.sync(rating)
      end.to raise_error Salesforce::UserSkillRatingsRepository::SyncFailed, /id=42/
    end
  end
end
