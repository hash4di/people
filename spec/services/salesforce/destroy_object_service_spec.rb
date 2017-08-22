require 'spec_helper'

describe Salesforce::DestroyObjectService do
  let(:object) { double(salesforce_id: salesforce_id) }
  subject { described_class.new }

  describe '#call' do
    let(:api_name) { 'ApiName__c' }
    let(:sf_client) { double }
    let(:call_params) { { api_name: api_name, object: object } }
    let(:call) { subject.call(call_params) }

    before { allow(subject).to receive(:sf_client).and_return(sf_client) }

    context 'when salesforce_id is nil' do
      let(:salesforce_id) { nil }

      it 'returns false' do
        expect(call).to be false
      end
    end

    context 'when salesforce_id is invalid' do
      let(:salesforce_id) { 'asidjfioej' }
      let(:error) { Faraday::ClientError.new('error message') }

      before do
        allow(sf_client).to receive(:find).with(api_name, salesforce_id).and_raise(error)
      end

      it 'suppresses faraday error' do
        expect { call }.not_to raise_error(error)
      end

      it 'returns false' do
        expect(call).to be false
      end

      context 'when notifications are enabled' do
        let(:call_params) { { api_name: api_name, object: object, notify: true } }
        let(:rollbar_params) do
          [
            error,
            'Unable to delete SF record',
            { api_name: api_name, object: object }
          ]
        end
        let(:error_params) { { error: error, api_name: api_name, object: object } }
        let(:notification) { double(message: 'bla') }
        let(:slack_notifier) { double }

        it 'sends rollbar notification' do
          expect(Rollbar).to receive(:error).with(*rollbar_params)
          call
        end

        it 'sends slack notification' do
          allow(subject).to receive(:slack_notifier).and_return(slack_notifier)
          allow(slack_notifier).to receive(:ping).with(notification)
          expect(NotificationMessage::Skill::UnableToDelete).to receive(:new).with(error_params).and_return(notification)
          call
        end
      end
    end

    context 'when salesforce_id is valid' do
      let(:salesforce_id) { 'a067E000009SXNuQAO' }
      let(:sf_object) { double(destroy: true) }
      let(:sf_client) { double(find: sf_object) }

      it 'destroys the object' do
        expect(call).to be true
      end
    end
  end
end
