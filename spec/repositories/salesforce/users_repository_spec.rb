require 'spec_helper'

RSpec.describe Salesforce::UsersRepository do
  it_behaves_like "generic salesforce repository" do
    let(:local_resource) do
      User.new(id: 42, first_name: "John", last_name: "Doe")
    end
    let(:salesforce_resource_name) { "Developer__c" }
    let(:expected_salesforce_attributes) do
      { Name: "John Doe" }
    end
  end
end
