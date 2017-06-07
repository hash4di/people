require 'spec_helper'

RSpec.describe Salesforce::UsersRepository do
  it_behaves_like "generic salesforce repository" do

    let(:local_resource) do
      User.new(id: 42, first_name: "John", last_name: "Doe")
    end
    let(:salesforce_resource_name) { "Contact" }
    let(:expected_salesforce_create_attributes) do
      {
        AccountId: described_class::NETGURU_ACCOUNT_ID,
        FirstName: 'John',
        LastName: 'Doe',
      }
    end
    let(:expected_salesforce_update_attributes) do
      expected_salesforce_create_attributes
    end
  end
end
