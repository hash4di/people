require 'spec_helper'

describe Salesforce::DestroyObjectService do
  subject { described_class.new }

  describe '#call' do
    let(:api_name) { 'ApiName__c' }
    let(:sf_client) { double }

    before { allow(subject).to receive(:sf_client).and_return(sf_client) }

    context 'when salesforce_id is nil' do
      let(:salesforce_id) { nil }

      it 'returns false' do
        expect(subject.call(api_name, salesforce_id)).to be false
      end
    end

    context 'when salesforce_id is invalid' do
      let(:salesforce_id) { 'asidjfioej' }

      before do
        allow(sf_client).to receive(:find).with(api_name, salesforce_id).and_raise(Faraday::ResourceNotFound, '')
      end

      it 'suppresses faraday error' do
        expect { subject.call(api_name, salesforce_id) }.not_to raise_error(Faraday::ResourceNotFound)
      end

      it 'returns false' do
        expect(subject.call(api_name, salesforce_id)).to be false
      end
    end

    context 'when salesforce_id is valid' do
      let(:salesforce_id) { 'a067E000009SXNuQAO' }
      let(:sf_object) { double(destroy: true) }
      let(:sf_client) { double(find: sf_object) }

      it 'destroys the object' do
        expect(subject.call(api_name, salesforce_id)).to be true
      end
    end
  end
end
