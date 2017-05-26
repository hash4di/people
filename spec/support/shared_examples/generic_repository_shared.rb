RSpec.shared_examples 'generic salesforce repository' do
  let(:local_resource) { fail 'you need to override :local_resource' }
  let(:salesforce_resource_name) { fail 'you need to override :salesforce_resource_name' }
  let(:expected_salesforce_attributes) do
    fail 'you need to override :expected_salesforce_attributes'
  end

  let(:repository) { described_class.new(salesforce) }
  let(:salesforce) { double('Salesforce') }

  def set_salesforce_expectation(action, result, attrs)
    expect(salesforce).to receive(action).with(salesforce_resource_name, attrs).and_return(result)
  end

  context "local resource wasn't synced before" do
    it 'creates new entry in Salesforce' do
      set_salesforce_expectation(:create, 'sf_id', expected_salesforce_create_attributes)
      expect(local_resource).to receive(:update_column).with(:salesforce_id, 'sf_id')
      repository.sync(local_resource)
    end

    it "raises error if couldn't be created" do
      set_salesforce_expectation(:create, false, expected_salesforce_create_attributes)
      expect do
        repository.sync(local_resource)
      end.to raise_error described_class::SyncFailed, /id=#{ local_resource.id }/
    end
  end

  context 'local_resource was synced before' do
    before do
      local_resource.salesforce_id = 'sf_id'
    end

    it 'updates old entry in Salesforce' do
      set_salesforce_expectation(:update, true, expected_salesforce_update_attributes.merge(Id: 'sf_id'))
      repository.sync(local_resource)
    end

    it "raises error if couldn't be updated" do
      set_salesforce_expectation(:update, false, expected_salesforce_update_attributes.merge(Id: 'sf_id'))
      expect do
        repository.sync(local_resource)
      end.to raise_error described_class::SyncFailed, /id=#{ local_resource.id }/
    end
  end
end
