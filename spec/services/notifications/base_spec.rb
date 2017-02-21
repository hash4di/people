require 'spec_helper'

describe Notifications::Base do
  subject { described_class.new(notifiable_id: skill.id) }

  let(:skill) { create(:skill) }

  describe '#notify' do
    let(:notification_status) { Notification::STATUSES.sample }
    let(:notification_type) { Notification::TYPES.sample }
    let(:notifiable_type) { 'Skill' }
    let(:receivers) { create_list(:user, 2) }

    before do
      allow_any_instance_of(described_class).to receive(
        :notification_status
      ).and_return(notification_status)
    end

    context 'when status is not allowed' do
      let(:notification_status) { 'wrong_status' }
      let(:expected_error) do
        "Notifications status: #{notification_status} is not allowed. Allowed statuses: #{Notification::STATUSES}"
      end

      it 'raises error' do
        expect { subject.notify }.to raise_error(expected_error)
        expect { subject.notify }.to raise_error(
          Notifications::Base::UnexpectedStatusType
        )
      end
    end

    context 'when type is not allowed' do
      let(:notification_type) { 'wrong_type' }
      let(:expected_error) do
        "Notifications type: #{notification_type} is not allowed. Allowed statuses: #{Notification::TYPES}"
      end

      before do
        allow_any_instance_of(described_class).to receive(
          :notification_type
        ).and_return(notification_type)
      end

      it 'raises error' do
        expect { subject.notify }.to raise_error(expected_error)
        expect { subject.notify }.to raise_error(
          Notifications::Base::UnexpectedType
        )
      end
    end

    context 'when type is not set' do
      let(:expected_error) do
        "Please define notification_type method to your notification service"
      end

      it 'raises error' do
        expect { subject.notify }.to raise_error(expected_error)
        expect { subject.notify }.to raise_error(
          Notifications::Base::NotificationTypeNotFound
        )
      end
    end

    context 'when notifiable type is not set' do
      let(:expected_error) do
        'Please define notifiable_type method to your notification service'
      end

      before do
        allow_any_instance_of(described_class).to receive(
          :notification_type
        ).and_return(notification_type)
        allow_any_instance_of(described_class).to receive(
          :receivers
        ).and_return(receivers)
      end

      it 'raises error' do
        expect { subject.notify }.to raise_error(expected_error)
        expect { subject.notify }.to raise_error(
          Notifications::Base::NotifiableTypeNotFound
        )
      end
    end

    context 'when receivers are not set' do
      let(:expected_error) do
        'Please define receivers method to your notification service'
      end

      before do
        allow_any_instance_of(described_class).to receive(
          :notification_type
        ).and_return(notification_type)
        allow_any_instance_of(described_class).to receive(
          :notifiable_type
        ).and_return(notifiable_type)
      end

      it 'raises error' do
        expect { subject.notify }.to raise_error(expected_error)
        expect { subject.notify }.to raise_error(
          Notifications::Base::ReceiversNotFound
        )
      end
    end
  end
end
