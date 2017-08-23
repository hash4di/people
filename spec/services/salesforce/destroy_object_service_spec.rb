require 'spec_helper'

describe Salesforce::DestroyObjectService do
  let(:object) { double(salesforce_id: sf_id) }
  subject { described_class.new }

  describe '#call' do
    let(:api_name) { 'ApiName__c' }
    let(:sf_client) { double }
    let(:call_params) { { api_name: api_name, object: object } }
    let(:call) { subject.call(call_params) }

    before { allow(subject).to receive(:sf_client).and_return(sf_client) }

    context 'when salesforce_id is nil' do
      let(:sf_id) { nil }

      it 'returns false' do
        expect(call).to be true
      end
    end

    context 'when salesforce_id is invalid' do
      let(:sf_id) { 'asidjfioej' }
      let(:error) { Faraday::ClientError.new('error message') }
      let(:error_params) { { error: error, api_name: api_name, object: object } }
      let(:rollbar_params) do
        [
          error,
          'Unable to delete SF record',
          { api_name: api_name, object: object }
        ]
      end
      let(:notification) { double(message: 'bla') }
      let(:slack_notifier) { double }

      before do
        allow(sf_client).to receive(:find).with(api_name, sf_id).and_raise(error)
        allow(subject).to receive(:slack_notifier).and_return(slack_notifier)
        allow(NotificationMessage::UnableToDelete).to receive(:new).with(error_params).and_return(notification)
        allow(slack_notifier).to receive(:ping).with(notification)
      end

      it 'suppresses faraday error' do
        expect { call }.not_to raise_error(error)
      end

      it 'returns false' do
        expect(call).to be false
      end

      it 'sends rollbar notification' do
        expect(Rollbar).to receive(:error).with(*rollbar_params)
        call
      end

      it 'sends slack notification' do
        expect(slack_notifier).to receive(:ping).with(notification)
        call
      end
    end

    context 'when salesforce_id is valid' do
      let(:sf_id) { 'a067E000009SXNuQAO' }
      let(:sf_object) { double(destroy: true) }
      let(:sf_client) { double(find: sf_object) }

      it 'destroys the object' do
        expect(call).to be true
      end
    end
  end
end
